package com.suryansh.repository;

import com.suryansh.entity.CategoryEntity;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<CategoryEntity, Long> {
    @EntityGraph(attributePaths = {"tags"})
    @Query("select  c from CategoryEntity c left join fetch c.tags where c.user.id = :userId")
    List<CategoryEntity> getCategoriesForUser(@Param("userId") long userID);
}
