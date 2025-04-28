package com.suryansh.repository;

import com.suryansh.entity.TagEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.Set;

@Repository
public interface TagRepository extends JpaRepository<TagEntity, Long> {
    @Query("select t from TagEntity t where t.name= :tagName")
    Optional<TagEntity> findByTagName(@Param("tagName") String tagName);

    @Query("select t from TagEntity t inner join t.categories c where c.id = :categoryId")
    Set<TagEntity> findTagsByCategory(@Param("categoryId") long categoryId);
}
