package com.suryansh.repository;

import com.suryansh.entity.UserEntity;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    @Query("select case when count(u) > 0 then true else false END from UserDetailEntity u where u.email=:email or u.contact=:contact")
    boolean checkUserEmailAndContactIsPresent(@Param("contact") String contact,@Param("email") String email);

    @Query("SELECT u from UserEntity u left join FETCH u.userDetail where u.id =:id")
    Optional<UserEntity> getUserInfoById(int id);

    @EntityGraph(attributePaths = {"categories", "userDetail"})
    @Query("select distinct u from UserEntity u where u.id = :userId")
    Optional<UserEntity> findUserWithCategories(@Param("userId") long userId);

}
