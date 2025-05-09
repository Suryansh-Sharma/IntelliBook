package com.suryansh.service.interfaces;

import com.suryansh.dto.CategoryDto;

import java.util.List;

public interface CategoryService {
    String addNewCategory(long userID, String name, String description);

    List<CategoryDto> categoriesForUser(long userID);

    String addNewTag(long categoryId, String name, String description);

    String updateCategory(long categoryId, String name, String description);

    String updateTag(long tagId, String name, String description);
}
