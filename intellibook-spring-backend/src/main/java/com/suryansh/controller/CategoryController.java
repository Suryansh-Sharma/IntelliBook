package com.suryansh.controller;

import com.suryansh.dto.CategoryDto;
import com.suryansh.security.UserPrincipal;
import com.suryansh.service.interfaces.CategoryService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class CategoryController {
    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    private long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();
        return Long.parseLong(principal.getUsername());
    }

    @MutationMapping
    @PreAuthorize("isAuthenticated()")
    public String addNewCategory(@Argument("name") String name,
                                 @Argument("description") String description) {
        return categoryService.addNewCategory(getCurrentUserId(),name,description);
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public List<CategoryDto> getCategoriesForUser() {
        return categoryService.categoriesForUser(getCurrentUserId());
    }

    @MutationMapping
    @PreAuthorize("isAuthenticated()")
    public String addNewTagToCategory(@Argument("categoryId") long categoryId,
                                      @Argument("name") String name,
                                      @Argument("description") String description){
        return categoryService.addNewTag(categoryId,name,description);
    }

    @MutationMapping
    @PreAuthorize("isAuthenticated()")
    public String updateCategory(@Argument("categoryId")long categoryId,@Argument("name") String name,
                                 @Argument("description") String description){
        return categoryService.updateCategory(categoryId,name,description);
    }

    @MutationMapping
    @PreAuthorize("isAuthenticated()")
    public String updateTag(@Argument("tagId")long tagId,@Argument("name") String name,
                            @Argument("description")String description){
        return categoryService.updateTag(tagId,name,description);
    }
}
