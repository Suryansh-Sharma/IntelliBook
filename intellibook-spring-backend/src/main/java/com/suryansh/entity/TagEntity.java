package com.suryansh.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.*;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Table(name = "tag")

public class TagEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String description;

    @ManyToMany
    @JoinTable(
            name = "category_tags",
            joinColumns = @JoinColumn(name = "tag_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    List<CategoryEntity>categories=new ArrayList<>();

    @ManyToMany(mappedBy = "tags",cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    Set<TransactionEntity> transactions = new HashSet<>();

    @Override
    public final boolean equals(Object o) {
        if (!(o instanceof TagEntity tagEntity)) return false;

        return Objects.equals(getId(), tagEntity.getId()) && Objects.equals(getName(), tagEntity.getName()) && Objects.equals(getDescription(), tagEntity.getDescription());
    }

    @Override
    public int hashCode() {
        int result = Objects.hashCode(getId());
        result = 31 * result + Objects.hashCode(getName());
        result = 31 * result + Objects.hashCode(getDescription());
        return result;
    }
}
