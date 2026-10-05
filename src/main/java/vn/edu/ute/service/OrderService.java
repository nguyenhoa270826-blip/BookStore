package vn.edu.ute.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.edu.ute.entity.Book;
import vn.edu.ute.entity.Order;
import vn.edu.ute.entity.OrderDetail;
import vn.edu.ute.entity.User;
import vn.edu.ute.model.CartItem;
import vn.edu.ute.repository.BookRepository;
import vn.edu.ute.repository.OrderRepository;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private EmailService emailService;

    /**
     * Tạo đơn hàng thanh toán bằng COD (Cash on Delivery)
     */
    @Transactional
    public Order createCODOrder(User user, String recipientName, String phone,
                               String shippingAddress, String note,
                               Map<Integer, CartItem> cart) throws Exception {
        if (cart == null || cart.isEmpty()) {
            throw new Exception("Giỏ hàng của bạn đang trống!");
        }

        // Tạo mã đơn hàng duy nhất: ORD-YYYYMMDD-HHmmss
        String orderCode = "ORD-" + new SimpleDateFormat("yyyyMMdd-HHmmss").format(new Date());

        Order order = new Order();
        order.setOrderCode(orderCode);
        order.setUser(user);
        order.setRecipientName(recipientName);
        order.setPhone(phone);
        order.setShippingAddress(shippingAddress);
        order.setNote(note);
        order.setPaymentMethod("COD");
        order.setStatus(Order.STATUS_NEW); // Trạng thái ban đầu: "Đơn hàng mới"
        order.setCreatedAt(new Date());
        order.setUpdatedAt(new Date());

        BigDecimal total = BigDecimal.ZERO;

        for (CartItem item : cart.values()) {
            Book book = bookRepository.findById(item.getBookid())
                .orElseThrow(() -> new Exception("Sách không tồn tại: " + item.getTitle()));

            int currentStock = book.getQuantity() != null ? book.getQuantity() : 0;
            if (currentStock < item.getQuantity()) {
                throw new Exception("Sách '" + book.getTitle() + "' không đủ số lượng trong kho! (Còn: " + currentStock + ")");
            }

            // Trừ tồn kho trong DB
            book.setQuantity(currentStock - item.getQuantity());
            bookRepository.save(book);

            // Tạo chi tiết đơn hàng
            OrderDetail detail = new OrderDetail(order, book, item.getPrice(), item.getQuantity());
            order.addDetail(detail);

            total = total.add(detail.getSubtotal());
        }

        order.setTotalAmount(total);
        Order savedOrder = orderRepository.save(order);

        // Gửi email xác nhận COD
        try {
            emailService.sendOrderConfirmationEmail(user.getEmail(), savedOrder.getOrderCode(), total.toString() + " $");
        } catch (Exception e) {
            // bỏ qua lỗi mail
        }

        return savedOrder;
    }

    public List<Order> getOrdersByUser(User user, String statusFilter) {
        if (statusFilter == null || statusFilter.trim().isEmpty() || "ALL".equalsIgnoreCase(statusFilter)) {
            return orderRepository.findByUserOrderByCreatedAtDesc(user);
        }
        return orderRepository.findByUserAndStatusOrderByCreatedAtDesc(user, statusFilter);
    }

    public Optional<Order> getOrderById(Integer orderId) {
        return orderRepository.findById(orderId);
    }

    /**
     * Cập nhật trạng thái đơn hàng (Mô phỏng thao tác database theo 8 trạng thái đề bài)
     */
    @Transactional
    public Order updateOrderStatus(Integer orderId, String newStatus) throws Exception {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new Exception("Không tìm thấy đơn hàng ID: " + orderId));
        order.setStatus(newStatus);
        order.setUpdatedAt(new Date());
        return orderRepository.save(order);
    }

    public long countByStatus(User user, String status) {
        return orderRepository.countByUserAndStatus(user, status);
    }

    public long countAllByUser(User user) {
        return orderRepository.countByUser(user);
    }
}