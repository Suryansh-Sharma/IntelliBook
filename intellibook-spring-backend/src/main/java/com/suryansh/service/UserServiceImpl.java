package com.suryansh.service;

import com.suryansh.dto.SearchRecordDto;
import com.suryansh.dto.UserInfoDto;
import com.suryansh.dto.UserLoginResDto;
import com.suryansh.entity.*;
import com.suryansh.exception.SpringIntelliBookEx;
import com.suryansh.model.AddNewUserModel;
import com.suryansh.model.SearchRecordModel;
import com.suryansh.repository.InvalidJwtRepo;
import com.suryansh.repository.RefreshTokenRepo;
import com.suryansh.repository.UserRepository;
import com.suryansh.security.JwtService;
import com.suryansh.service.interfaces.UserService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Tuple;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;

@Service
public class UserServiceImpl implements UserService {
    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);
    private final UserRepository userRepository;
    private final MappingService mappingService;
    private final EntityManager entityManager;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final RefreshTokenRepo refreshTokenRepo;
    private final InvalidJwtRepo invalidJwtRepo;
    private final CachingService cachingService;

    public UserServiceImpl(UserRepository userRepository, MappingService mappingService, EntityManager entityManager, PasswordEncoder passwordEncoder, JwtService jwtService, RefreshTokenRepo refreshTokenRepo, InvalidJwtRepo invalidJwtRepo, CachingService cachingService) {
        this.userRepository = userRepository;
        this.mappingService = mappingService;
        this.entityManager = entityManager;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.refreshTokenRepo = refreshTokenRepo;
        this.invalidJwtRepo = invalidJwtRepo;
        this.cachingService = cachingService;
    }
    @Value("${expiration_time}")
    private String EXPIRATION_TIME;
    @Value("${refresh_token_validity}")
    private long REFRESH_TOKEN_TIME;

    @Override
    public UserLoginResDto addNewUser(AddNewUserModel model) {
        boolean isUserExist = userRepository.checkUserEmailAndContactIsPresent(model.getContact(), model.getEmail());
        if (isUserExist) {
            throw new SpringIntelliBookEx("User Email or Contact is present !!, It must be unique", "EMAIL_CONTACT_PRESENT",
                    HttpStatus.BAD_REQUEST);
        }
        UserEntity userEntity = mappingService.mapUserModelToEntity(model);
        try {
            userEntity = userRepository.saveAndFlush(userEntity);
            logger.info("New User created successfully ");
            Map<String, Object> claims = new HashMap<>();
            claims.put("role", model.getRole());
            String userId = String.valueOf(userEntity.getId());
            String jwtToken = jwtService.generateToken(userId, claims);
            RefreshTokenEntity refreshTokenEntity = generateRefreshToken(userEntity.getUserDetail());
            try{
                refreshTokenRepo.save(refreshTokenEntity);
            }catch (Exception e){
                throw new SpringIntelliBookEx("Refresh token generation failed", e.getMessage(), HttpStatus.BAD_REQUEST);
            }
            return mappingService.mapUserEntityToLoginDto(userEntity, userEntity.getUserDetail(), jwtToken, refreshTokenEntity);
        } catch (Exception e) {
            logger.error("Unable to create new user {}", e.getMessage());
            throw new SpringIntelliBookEx("New User creation failed", e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public UserLoginResDto handleLoginUser(String username, String password) {
//        Retrieve User by contact or email
        UserDetailEntity ud = userRepository.getUserByContactOrEmail(username)
                .orElseThrow(() -> new SpringIntelliBookEx("User not found", "USER_NOT_FOUND", HttpStatus.NOT_FOUND));
//        Validate User Password
        if (!passwordEncoder.matches(password, ud.getPassword())) {
            throw new SpringIntelliBookEx("Wrong password", "WRONG_PASSWORD", HttpStatus.BAD_REQUEST);
        }
        String userId = String.valueOf(ud.getId());
//        Prepare Claims
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", ud.getRole());
        String jwtToken = jwtService.generateToken(userId, claims);
        UserEntity userEntity = ud.getUser();
        RefreshTokenEntity refreshTokenEntity = generateRefreshToken(ud);
        try{
            refreshTokenRepo.save(refreshTokenEntity);
        }catch (Exception e){
            throw new SpringIntelliBookEx("Refresh token generation failed", e.getMessage(), HttpStatus.BAD_REQUEST);
        }
        return mappingService.mapUserEntityToLoginDto(userEntity, ud, jwtToken, refreshTokenEntity);
    }

    @Override
    public UserLoginResDto.JwtToken reGenToken(String token) {
        ZonedDateTime nowInIndia = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
        RefreshTokenEntity refreshToken = refreshTokenRepo.findById(token)
                .orElseThrow(() -> new SpringIntelliBookEx("Refresh Token not found", "REFRESH_TOKEN_NOT_FOUND", HttpStatus.NOT_FOUND));
        // Check refresh token is expired or not.
        if (refreshToken.getExpiresAt().isBefore(nowInIndia.toInstant())) {
            try {
                refreshTokenRepo.deleteById(token);
            } catch (Exception e) {
                logger.error("Unable to delete refresh token {}", e.getMessage());
                throw new SpringIntelliBookEx("Unable to delete refresh token", "REFRESH_TOKEN_NOT_FOUND", HttpStatus.NOT_FOUND);
            }
            throw new SpringIntelliBookEx("Refresh Token expired, Regen by LOGIN", "REFRESH_TOKEN_EXPIRED", HttpStatus.BAD_REQUEST);
        }
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", refreshToken.getUserDetail().getRole());
        String userId = String.valueOf(refreshToken.getUserDetail().getId());
        String jwtToken = jwtService.generateToken(userId, claims);
        return new UserLoginResDto.JwtToken(
                jwtToken,
                "Token will expire in " + EXPIRATION_TIME + " minutes"
        );
    }

    @Override
    public String handleLogoutUser(String refreshToken, String jwtToken) {
        RefreshTokenEntity refreshTokenEntity = refreshTokenRepo.findById(refreshToken)
                .orElseThrow(()->new SpringIntelliBookEx("Refresh Token not found", "REFRESH_TOKEN_NOT_FOUND", HttpStatus.NOT_FOUND));
        ZonedDateTime nowInIndia = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
        InvalidJwtEntity invalidJwt = new InvalidJwtEntity();
        invalidJwt.setToken(jwtToken);
        invalidJwt.setLogoutAt(nowInIndia.toInstant());
        invalidJwt.setExpiresAt(jwtService.getTokenExpirationTime(jwtToken));
        try{
            boolean isJwtBlacklisted= cachingService.addInvalidJwt(jwtToken,invalidJwt);
            System.out.println("Token Blacklisted: " + isJwtBlacklisted);
            refreshTokenRepo.deleteById(refreshTokenEntity.getToken());
            return "User has been logged out successfully !!";
        }catch (Exception e){
            logger.error("Unable to logout user {}", e.getMessage());
            throw new SpringIntelliBookEx("Unable to logout", e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public UserInfoDto userById(long id) {
        UserEntity user = userRepository.getUserInfoById(id)
                .orElseThrow(() -> new SpringIntelliBookEx("User id not found for id :- " + id, "USER_NOT_FOUND", HttpStatus.NOT_FOUND));
        return new UserInfoDto(
                user.getId(),
                user.getFirstname(),
                user.getLastname(),
                user.getUserDetail().getContact(),
                user.getUserDetail().getEmail(),
                user.getUserDetail().getRole(),
                null,
                false,
                false
        );
    }

    @Override
    public SearchRecordDto searchRecords(long userId, SearchRecordModel searchRecordModel) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<Tuple> query = cb.createTupleQuery();
        Root<TransactionEntity> transactionRoot = query.from(TransactionEntity.class);

        Join<TransactionEntity, CategoryEntity> categoryJoin = transactionRoot.join("category", JoinType.LEFT);
        Join<TransactionEntity, TagEntity> tagJoin = transactionRoot.joinSet("tags", JoinType.LEFT);

        List<Predicate> predicates = new ArrayList<>();

        // Search Based On User.
        predicates.add(cb.equal(transactionRoot.get("user").get("id"), userId));

        boolean isCategoryFilterApplied = false;
        boolean isTransactionFilterApplied = false;
        boolean isTagFilterApplied = false;
        // Applying Filters.
        for (var filter : searchRecordModel.getFilters()) {
            switch (filter.getKey()) {
                case "filter.AllRecord" -> {
                }
                case "filter.Categories" -> {
                    predicates.add(cb.equal(categoryJoin.get("name"), filter.getValue().toUpperCase()));
                    isCategoryFilterApplied = true;
                }
                case "filter.Tags" -> {
                    predicates.add(cb.equal(tagJoin.get("name"), filter.getValue().toUpperCase()));
                    isTagFilterApplied = true;
                }
                case "filter.AmountRange" -> {
                    String[] amounts = filter.getValue().split("-");
                    predicates.add(cb.between(transactionRoot.get("amount"), new BigDecimal(amounts[0]),
                            new BigDecimal(amounts[1])));
                    isTransactionFilterApplied = true;
                }
                case "filter.DateRange" -> {
                    String[] dates = filter.getValue().split("to");
                    if (dates.length != 2 || dates[0].isBlank() || dates[1].isBlank()) {
                        throw new SpringIntelliBookEx("Date range should be in 'yyyy-MM-dd to yyyy-MM-dd' format.",
                                "INVALID_DATE_RANGE", HttpStatus.BAD_REQUEST);
                    }
                    Instant fromDateInstant, toDateInstant;
                    try {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                        fromDateInstant = LocalDate.parse(dates[0], formatter).atStartOfDay(ZoneId.of("Asia/Kolkata")).toInstant();
                        toDateInstant = LocalDate.parse(dates[1], formatter).atTime(23, 59, 59).atZone(ZoneId.of("Asia/Kolkata")).toInstant();

                    } catch (DateTimeParseException e) {
                        throw new SpringIntelliBookEx("Invalid date format. Use 'yyyy-MM-dd'",
                                "WRONG_DATE_FORMAT", HttpStatus.BAD_REQUEST);
                    }
                    predicates.add(cb.between(transactionRoot.get("timestamp"), fromDateInstant, toDateInstant));
                    isTransactionFilterApplied = true;
                }
                default ->
                        throw new SpringIntelliBookEx("Wrong Filter Key selection use only :- filter.AllRecord, filter.Tags, filter.Categories, filter.AmountRange, filter.DateRange ",
                                "WRONG_FILTER_KEY", HttpStatus.BAD_REQUEST);

            }
        }
        query.where(predicates.toArray(new Predicate[0]));
        if (isTransactionFilterApplied) {
            query.multiselect(
                    transactionRoot.get("id").alias("transactionId"),
                    transactionRoot.get("amount").alias("amount")
            );
        } else if (isCategoryFilterApplied) {
            query.multiselect(
                    categoryJoin.get("id").alias("categoryId"),
                    categoryJoin.get("name").alias("categoryName")
            );
        } else if (isTagFilterApplied) {
            query.multiselect(
                    tagJoin.get("id").alias("tagId"),
                    tagJoin.get("name").alias("tagName")
            );
        } else {
            query.multiselect(
                    transactionRoot.get("id").alias("transactionId"),
                    transactionRoot.get("amount").alias("amount"),
                    categoryJoin.get("id").alias("categoryId"),
                    categoryJoin.get("name").alias("categoryName"),
                    tagJoin.get("id").alias("tagId"),
                    tagJoin.get("name").alias("tagName")
            );
        }

        // Apply Sorting.
        String sortBy = searchRecordModel.getSortBy();
        String sortOrder = searchRecordModel.getSortOrder();

        Path<?> sortingField = switch (sortBy) {
            case "amount" -> transactionRoot.get("amount");
            case "categoryId" -> categoryJoin.get("id");
            case "categoryName" -> categoryJoin.get("name");
            case "tagId" -> tagJoin.get("id");
            case "tagName" -> tagJoin.get("name");
            case "timestamp" -> transactionRoot.get("timestamp");
            default -> transactionRoot.get("id");
        };
        Order order = "desc".equalsIgnoreCase(sortOrder) ? cb.desc(sortingField) : cb.asc(sortingField);
        query.orderBy(order);

        TypedQuery<Tuple> typedQuery = entityManager.createQuery(query);
        typedQuery.setMaxResults(7);
        List<Tuple> resultList = typedQuery.getResultList();

        // Parse Query Res into Dto
        SearchRecordDto res;

        if (isTransactionFilterApplied) {
            res = parseTransactionTupleToSearchRecordDto(resultList);
        } else if (isCategoryFilterApplied) {
            res = parseCategoryTupleToSearchRecordDto(resultList);
        } else if (isTagFilterApplied) {
            res = parseTagTupleToSearchRecordDto(resultList);
        } else {
            res = parseTupleListToSearchRecordDto(resultList);
        }

        res.setValue(searchRecordModel.getValue());
        res.setSortBy(sortBy);
        res.setSortOrder(sortOrder);

        return res;
    }


    private SearchRecordDto parseTupleListToSearchRecordDto(List<Tuple> tupleList) {
        SearchRecordDto searchRecordDto = new SearchRecordDto();

        Set<SearchRecordDto.SearchResTransactionDto> transactionSet = new HashSet<>();
        Set<SearchRecordDto.SearchResCategoryDto> categorySet = new HashSet<>();
        Set<SearchRecordDto.SearchResTagDto> TagsSet = new HashSet<>();

        for (Tuple tuple : tupleList) {
            long id = ((Number) tuple.get(0)).longValue();
            BigDecimal amount = new BigDecimal(tuple.get(1).toString());
            long categoryId = ((Number) tuple.get(2)).longValue();
            String categoryName = (String) tuple.get(3);
            long tagId = ((Number) tuple.get(4)).longValue();
            String tagName = (String) tuple.get(5);

            // Populate Transaction
            SearchRecordDto.SearchResTransactionDto transaction = new SearchRecordDto.SearchResTransactionDto();
            transaction.setId(id);
            transaction.setAmount(amount);
            transactionSet.add(transaction);

            // Populate Category
            SearchRecordDto.SearchResCategoryDto category = new SearchRecordDto.SearchResCategoryDto();
            category.setId(categoryId);
            category.setName(categoryName);
            categorySet.add(category);

            // Populate Tag
            SearchRecordDto.SearchResTagDto tag = new SearchRecordDto.SearchResTagDto();
            tag.setId(tagId);
            tag.setName(tagName);
            TagsSet.add(tag);
        }
        searchRecordDto.setCategories(new ArrayList<>(categorySet));
        searchRecordDto.setTags(new ArrayList<>(TagsSet));
        searchRecordDto.setTransactions(new ArrayList<>(transactionSet));

        return searchRecordDto;
    }

    private SearchRecordDto parseCategoryTupleToSearchRecordDto(List<Tuple> resultList) {
        SearchRecordDto dto = new SearchRecordDto();

        Set<SearchRecordDto.SearchResCategoryDto> categorySet = new HashSet<>();

        for (Tuple tuple : resultList) {
            long categoryId = ((Number) tuple.get(0)).longValue();
            String categoryName = (String) tuple.get(1);

            categorySet.add(new SearchRecordDto.SearchResCategoryDto(categoryId, categoryName));
        }

        dto.setCategories(new ArrayList<>(categorySet));
        return dto;
    }

    private SearchRecordDto parseTransactionTupleToSearchRecordDto(List<Tuple> resultList) {
        SearchRecordDto dto = new SearchRecordDto();

        Set<SearchRecordDto.SearchResTransactionDto> transactionSet = new HashSet<>();

        for (Tuple tuple : resultList) {
            long transactionId = ((Number) tuple.get(0)).longValue();
            BigDecimal amount = new BigDecimal(tuple.get(1).toString());
            SearchRecordDto.SearchResTransactionDto transaction = new SearchRecordDto.SearchResTransactionDto();
            transaction.setId(transactionId);
            transaction.setAmount(amount);
            transactionSet.add(transaction);
        }

        dto.setTransactions(new ArrayList<>(transactionSet));
        return dto;
    }

    private SearchRecordDto parseTagTupleToSearchRecordDto(List<Tuple> resultList) {
        SearchRecordDto dto = new SearchRecordDto();

        Set<SearchRecordDto.SearchResTagDto> tagSet = new HashSet<>();

        for (Tuple tuple : resultList) {
            long tagId = ((Number) tuple.get(0)).longValue();
            String tagName = (String) tuple.get(1);
            SearchRecordDto.SearchResTagDto tag = new SearchRecordDto.SearchResTagDto();
            tag.setId(tagId);
            tag.setName(tagName);
            tagSet.add(tag);
        }

        dto.setTags(new ArrayList<>(tagSet));
        return dto;
    }

    private RefreshTokenEntity generateRefreshToken(UserDetailEntity userDetailEntity) {
        ZonedDateTime nowInIndia = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
        RefreshTokenEntity refreshTokenEntity = new RefreshTokenEntity();
        refreshTokenEntity.setToken(UUID.randomUUID().toString());
        refreshTokenEntity.setCreatedAt(nowInIndia.toInstant());
        refreshTokenEntity.setExpiresAt(nowInIndia.plusDays(REFRESH_TOKEN_TIME).toInstant());
        refreshTokenEntity.setUserDetail(userDetailEntity);
        return refreshTokenEntity;
    }
}
