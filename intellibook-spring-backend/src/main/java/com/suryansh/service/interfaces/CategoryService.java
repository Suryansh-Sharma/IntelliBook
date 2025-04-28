package com.suryansh.service.interfaces;

import com.suryansh.dto.CategoryDto;

import java.util.List;

public interface CategoryService {
    String addNewCategory(int userID, String name, String description);

    List<CategoryDto> categoriesForUser(int userID);

    String addNewTag(long categoryId, String name, String description);

    String updateCategory(long categoryId, String name, String description);

    String updateTag(long tagId, String name, String description);
}
