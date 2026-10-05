package vn.edu.ute.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.edu.ute.entity.Author;

@Repository
public interface AuthorRepository extends JpaRepository<Author, Integer> {
    Page<Author> findAll(Pageable pageable);
    Page<Author> findByAuthorNameContainingIgnoreCase(String authorName, Pageable pageable);
}