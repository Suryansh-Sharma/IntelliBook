package com.suryansh.repository;

import com.suryansh.entity.TransactionEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface TransactionRepository extends JpaRepository<TransactionEntity, Long> {
    @Query("SELECT t FROM TransactionEntity t " +
            "LEFT JOIN FETCH t.category " +
            "LEFT JOIN FETCH t.user u " +
            "LEFT JOIN FETCH u.userDetail " +
            "LEFT JOIN FETCH t.tags " +
            "WHERE t.id = :transactionId")
    Optional<TransactionEntity> findTransactionFullDetailById(@Param("transactionId") long transactionId);

    @Query("SELECT t FROM TransactionEntity t " +
            "LEFT JOIN FETCH t.category " +
            "LEFT JOIN FETCH t.user u " +
            "LEFT JOIN FETCH u.userDetail " +
            "LEFT JOIN FETCH t.tags " +
            "WHERE u.id= :userId AND FUNCTION('DATE',t.timestamp) = :date")
    List<TransactionEntity> getByDate(@Param("userId") long userId, @Param("date") LocalDate date, Sort sort);

    @Query("SELECT t FROM TransactionEntity t " +
            "LEFT JOIN FETCH t.category " +
            "LEFT JOIN FETCH t.user u " +
            "LEFT JOIN FETCH t.tags " +
            "LEFT JOIN FETCH u.userDetail " +
            "WHERE u.id= :userId AND t.timestamp BETWEEN :from AND :to")
    Page<TransactionEntity> getTransactionsBetweenDate(@Param("userId") long userId, @Param("from") Instant from, @Param("to") Instant to, Pageable pageable);

    @Query("SELECT t FROM TransactionEntity t " +
            "LEFT JOIN FETCH t.category c " +
            "LEFT JOIN FETCH t.user u " +
            "LEFT JOIN FETCH u.userDetail " +
            "LEFT JOIN FETCH t.tags " +
            "WHERE u.id = :userId " +
            "AND c.name = :categoryName " +
            "AND t.timestamp BETWEEN :from AND :to")
    Page<TransactionEntity> getTransactionsBetweenDateByCategory(
            @Param("userId") long userId,
            @Param("categoryName") String category,
            @Param("from") Instant from,
            @Param("to") Instant to,
            Pageable pageable);

    @Query("SELECT DISTINCT t FROM TransactionEntity t " +
            "LEFT JOIN FETCH t.category c " +
            "LEFT JOIN FETCH t.user u " +
            "LEFT JOIN FETCH u.userDetail " +
            "LEFT JOIN t.tags tag " +
            "WHERE u.id = :userId " +
            "AND t.timestamp BETWEEN :from AND :to " +
            "AND tag.name = :tagName")
    Page<TransactionEntity> getTransactionsBetweenDateByTag(
            @Param("userId") long userId,
            @Param("tagName") String category,
            @Param("from") Instant from,
            @Param("to") Instant to,
            Pageable pageable);

    @Query(value = """
                    SELECT
                              TO_CHAR(t.timestamp, 'FMMonth') AS month,\s
                              COUNT(t.id) AS totalTransactions,\s
                              SUM(t.amount) AS totalAmount
                          FROM transaction t
                          WHERE t.user_id = :userId
                          AND t.timestamp BETWEEN :fromDate AND :toDate
                          GROUP BY EXTRACT(MONTH FROM t.timestamp), TO_CHAR(t.timestamp, 'FMMonth')
                          ORDER BY EXTRACT(MONTH FROM t.timestamp) ;
            
            """, nativeQuery = true)
    List<Object[]> getMonthlySummary(@Param("userId") Long userId,
                                     @Param("fromDate") Instant fromDate,
                                     @Param("toDate") Instant toDate);

    @Query(value = """
                    SELECT
                              TO_CHAR(t.timestamp, 'FMMonth') AS month,\s
                              COUNT(t.id) AS totalTransactions,\s
                              SUM(t.amount) AS totalAmount
                          FROM transaction t
                          JOIN category c on c.id = t.category_id
                          WHERE t.user_id = :userId
                          AND t.timestamp BETWEEN :fromDate AND :toDate
                          AND c.name = :categoryName
                          GROUP BY EXTRACT(MONTH FROM t.timestamp), TO_CHAR(t.timestamp, 'FMMonth')
                          ORDER BY EXTRACT(MONTH FROM t.timestamp) ;
            
            """, nativeQuery = true)
    List<Object[]> getMonthlySummaryByCategory(@Param("userId") long userId,
                                               @Param("fromDate") Instant fromDateInstant,
                                               @Param("toDate") Instant toDateInstant,
                                               @Param("categoryName") String categoryName);

    @Query(value = """
             SELECT\s
                 TO_CHAR(t.timestamp, 'FMMonth') AS month,
                 COUNT(t.id) AS totalTransactions,
                 SUM(t.amount) AS totalAmount
             FROM transaction t
             JOIN transaction_tags tt ON t.id = tt.transaction_id
             JOIN tag tg ON tt.tag_id = tg.id
             WHERE t.user_id = :userId
             AND t.timestamp BETWEEN :fromDate AND :toDate
             AND tg.name = :tagName
             GROUP BY EXTRACT(MONTH FROM t.timestamp), TO_CHAR(t.timestamp, 'FMMonth')
             ORDER BY EXTRACT(MONTH FROM t.timestamp);
            \s""", nativeQuery = true)
    List<Object[]> getMonthlySummaryByTag(@Param("userId") long userId,
                                          @Param("fromDate") Instant fromDate,
                                          @Param("toDate") Instant toDate, @Param("tagName") String tagName);

    @Query(value = """
              SELECT
            	TO_CHAR(T.TIMESTAMP, 'FMMonth') AS MONTH_NAME,
            	COALESCE(SUM(T.AMOUNT), 0) AS AMOUNT,
            	EXTRACT(
            		MONTH
            		FROM
            			T.TIMESTAMP
            	) AS MONTH_ORDER
            FROM
            	TRANSACTION T
            	JOIN CATEGORY C ON C.ID = T.CATEGORY_ID
            	LEFT JOIN TRANSACTION_TAGS TT ON T.ID = TT.TRANSACTION_ID
            	LEFT JOIN TAG TG ON TG.ID = TT.TAG_ID
            WHERE
            	T.USER_ID = :userId
            	AND T.TIMESTAMP BETWEEN :fromDate AND :toDate
            GROUP BY
            	TO_CHAR(T.TIMESTAMP, 'FMMonth'),
            	EXTRACT(
            		MONTH
            		FROM
            			T.TIMESTAMP
            	)
            ORDER BY
            	MONTH_ORDER
            """, nativeQuery = true)
    List<Object[]> getGroupedTransactionByTag(@Param("userId") long userId, @Param("fromDate") Instant fromDateInst, @Param("toDate") Instant toDateInst);

    @Query(value = """
                select c.id as category_id ,
                    c.name as category_name,
                    COALESCE(SUM(t.amount), 0) as total_amount,
                    COUNT(t.id) as transaction_count,
                    COALESCE(AVG(t.amount), 0)::int AS average_amount
                    FROM category c
                LEFT JOIN transaction t ON t.category_id = c.id
                WHERE t.user_id = :userId
                  AND t.timestamp BETWEEN :fromDate AND :toDate
                GROUP BY c.id,c.name
                ORDER BY SUM(t.amount) DESC
            """, nativeQuery = true)
    List<Object[]> getCategorySummary(@Param("userId") long userId,
                                      @Param("fromDate") Instant fromDate,
                                      @Param("toDate") Instant toDate);


    @Query(value = """
                    SELECT c.id AS category_id, tg.name AS tag_name, SUM(t.amount) AS tag_amount
                    from category c
                    join transaction t on t.id = t.category_id
                    join transaction_tags tt on t.id = tt.transaction_id 
                    join tag tg ON tt.tag_id = tg.id 
                    where t.user_id = :userId
                        and t.timestamp BETWEEN :fromDate AND :toDate
                    group by c.id, tg.name
                    order by c.id, tag_amount
            """, nativeQuery = true)
    List<Object[]> getTagSummaryPerCategory(@Param("userId") long userId, @Param("fromDate") Instant fromDate,
                                            @Param("toDate") Instant toDate);

    @Query(value = """
            SELECT
                TO_CHAR(T.TIMESTAMP, 'FMMonth') AS MONTH_NAME,
                EXTRACT(MONTH FROM T.TIMESTAMP) AS MONTH_ORDER,
                C.NAME AS CATEGORY_NAME,
                TG.NAME AS TAG_NAME,
                SUM(T.AMOUNT) AS TOTAL_AMOUNT,
                COUNT(T.ID) AS TRANSACTION_COUNT
            FROM
            	CATEGORY C
            	INNER JOIN CATEGORY_TAGS CT ON C.ID = CT.CATEGORY_ID
            	INNER JOIN TAG TG ON TG.ID = CT.TAG_ID
            	INNER JOIN "transaction" T ON T.CATEGORY_ID = C.ID
            	INNER JOIN USER_ENTITY U ON U.ID = T.USER_ID
            WHERE
            	U.ID = :userId
            	AND TG.NAME = :tagName
            	AND T.TIMESTAMP BETWEEN :start AND :end
            GROUP BY
                TO_CHAR(T.TIMESTAMP, 'FMMonth'),
                EXTRACT(MONTH FROM T.TIMESTAMP),
                C.NAME,
                TG.NAME
            ORDER BY
            	MONTH_ORDER;
            
            """, nativeQuery = true)
    List<Object[]> getCategorySummaryByTag(@Param("userId") long userId,@Param("start") Instant start,
                                           @Param("end") Instant end,@Param("tagName") String tagName);
}
