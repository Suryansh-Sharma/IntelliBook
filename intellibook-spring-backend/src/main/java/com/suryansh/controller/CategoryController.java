package com.suryansh.controller;

import com.suryansh.dto.CategoryDto;
import com.suryansh.service.interfaces.CategoryService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class CategoryController {
    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @MutationMapping
    public String addNewCategory(@Argument("userId") int userID,
                                 @Argument("name") String name,
                                 @Argument("description") String description) {
        return categoryService.addNewCategory(userID,name,description);
    }

    @QueryMapping
    public List<CategoryDto> getCategoriesForUser(@Argument("userId") int userID) {
        return categoryService.categoriesForUser(userID);
    }

    @MutationMapping
    public String addNewTagToCategory(@Argument("categoryId") long categoryId,
                                      @Argument("name") String name,
                                      @Argument("description") String description){
        return categoryService.addNewTag(categoryId,name,description);
    }

    @MutationMapping
    public String updateCategory(@Argument("categoryId")long categoryId,@Argument("name") String name,
                                 @Argument("description") String description){
        return categoryService.updateCategory(categoryId,name,description);
    }

    @MutationMapping
    public String updateTag(@Argument("tagId")long tagId,@Argument("name") String name,
                            @Argument("description")String description){
        return categoryService.updateTag(tagId,name,description);
    }
}
