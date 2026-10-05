package vn.edu.ute.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.edu.ute.entity.Rating;
import vn.edu.ute.entity.RatingId;
import java.util.List;

@Repository
public interface RatingRepository extends JpaRepository<Rating, RatingId> {
    List<Rating> findByBook_Bookid(Integer bookid);
    long countByBook_Bookid(Integer bookid);
}