package vn.edu.ute.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.edu.ute.entity.Order;
import vn.edu.ute.entity.User;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {
    List<Order> findByUserOrderByCreatedAtDesc(User user);
    List<Order> findByUserAndStatusOrderByCreatedAtDesc(User user, String status);
    long countByUserAndStatus(User user, String status);
    long countByUser(User user);
    Optional<Order> findByOrderCode(String orderCode);
    List<Order> findAllByOrderByCreatedAtDesc();
}