package com.suryansh.service;

import com.suryansh.dto.CategoryDto;
import com.suryansh.entity.CategoryEntity;
import com.suryansh.entity.TagEntity;
import com.suryansh.entity.UserEntity;
import com.suryansh.exception.SpringIntelliBookEx;
import com.suryansh.repository.CategoryRepository;
import com.suryansh.repository.TagRepository;
import com.suryansh.service.interfaces.CategoryService;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.graphql.execution.ErrorType;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {
    private static final Logger logger = LoggerFactory.getLogger(CategoryServiceImpl.class);
    private final CategoryRepository categoryRepository;
    private final TagRepository tagRepository;
    private final CachingService cachingService;

    public CategoryServiceImpl(CategoryRepository categoryRepository, TagRepository tagRepository, CachingService cachingService) {
        this.categoryRepository = categoryRepository;
        this.tagRepository = tagRepository;
        this.cachingService = cachingService;
    }

    @Override
    public String addNewCategory(long userID, String name, String description) {
        UserEntity user = cachingService.fetchUser(userID);
        user.getCategories().
                forEach(c->{
                    if (c.getName().equals(name)) {
                        throw new SpringIntelliBookEx("Category is already present ",
                                ErrorType.BAD_REQUEST.toString(),HttpStatus.BAD_REQUEST);
                    }
                });
        ZonedDateTime zonedDateTime = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
        CategoryEntity category = CategoryEntity.builder()
                .name(name.toUpperCase())
                .user(user)
                .description(description)
                .createdOn(zonedDateTime.toInstant())
                .build();
        try{
            categoryRepository.save(category);
            logger.info("Category added successfully");
            return "Added new category successfully !!";
        }catch (Exception e){
            logger.error("Unable to add new Category {}",e.getMessage());
            throw new SpringIntelliBookEx("Unable to Add new Category !!",
                    ErrorType.INTERNAL_ERROR.toString(),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public List<CategoryDto> categoriesForUser(long userID) {
        List<CategoryEntity>categoryEntities = categoryRepository.getCategoriesForUser(userID);
        return categoryEntities.stream()
                .map(c-> {
                    LocalDateTime createdOn = LocalDateTime.ofInstant(c.getCreatedOn(), ZoneId.of("Asia/Kolkata"));
                    List<CategoryDto.Tags> tags = c.getTags().stream()
                            .map(t->new CategoryDto.Tags(
                                    t.getId(),
                                    t.getName(),
                                    t.getDescription()
                            ))
                            .toList();
                    return new CategoryDto(
                            c.getId(),
                            c.getName(),
                            createdOn,
                            tags
                            );
                })
                .toList();
    }

    @Override
    public String addNewTag(long categoryId, String n, String description) {
        String name = n.toUpperCase();
        CategoryEntity category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new SpringIntelliBookEx("Category not found for ID: " + categoryId,
                        "CATEGORY_NOT_FOUND", HttpStatus.NOT_FOUND));
        category.getTags()
                .forEach(t->{
                    if (t.getName().equals(name)) {
                        throw new SpringIntelliBookEx("Tag name already exists !!",
                                ErrorType.BAD_REQUEST.toString(),HttpStatus.BAD_REQUEST);
                    }
                });
        TagEntity tagEntity = TagEntity.builder()
                .name(name)
                .description(description)
                .build();
        if (tagEntity.getCategories() == null) {
            tagEntity.setCategories(new ArrayList<>());
        }
        category.getTags().add(tagEntity);
        tagEntity.getCategories().add(category);
        try {
            categoryRepository.save(category);
            logger.info("Tag added to {} successfully !!",category.getName());
            return "Added new tag successfully !!";
        }catch (Exception e){
            logger.error("Unable to add new Tag {}",e.getMessage());
            throw new SpringIntelliBookEx("Unable to add Tag ",
                    ErrorType.INTERNAL_ERROR.toString(),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public String updateCategory(long categoryId, String name, String description) {
        CategoryEntity category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new SpringIntelliBookEx("Category not found for ID: " + categoryId,
                        "CATEGORY_NOT_FOUND", HttpStatus.NOT_FOUND));
        category.setName(name.toUpperCase());
        category.setDescription(description);
        try {
            categoryRepository.save(category);
            logger.info("Category {} updated successfully !!",category.getName());
            return "Updated category successfully !!";
        }catch (Exception e){
            logger.error("Unable to update Category {}",e.getMessage());
            throw new SpringIntelliBookEx("Unable to update category ",ErrorType.INTERNAL_ERROR.toString(),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public String updateTag(long tagId, String name, String description) {
        TagEntity tagEntity = tagRepository.findById(tagId)
                .orElseThrow(()->new SpringIntelliBookEx("Unable to find tag id :- "+tagId,"TAG_NOT_FOUND", HttpStatus.NOT_FOUND));
        tagEntity.setName(name.toUpperCase());
        tagEntity.setDescription(description);
        try {
            tagRepository.save(tagEntity);
            logger.info("Tag {} updated successfully !!",tagEntity.getName());
            return "Updated category successfully !!";
        }catch (Exception e){
            logger.error("Unable to update Tag {}",e.getMessage());
            throw new SpringIntelliBookEx("Unable to update tag ",ErrorType.INTERNAL_ERROR.toString(),HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
