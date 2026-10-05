package vn.edu.ute.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "orders")
public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    // 8 trạng thái chuẩn theo đề bài:
    // 1. Đơn hàng mới | 2. Đã xác nhận | 3. Chuẩn bị hàng | 4. Vận chuyển
    // 5. Giao hàng    | 6. Đã giao     | 7. Đơn hàng hủy  | 8. Đơn hàng hoàn
    public static final String STATUS_NEW = "Đơn hàng mới";
    public static final String STATUS_CONFIRMED = "Đã xác nhận";
    public static final String STATUS_PREPARING = "Chuẩn bị hàng";
    public static final String STATUS_SHIPPING = "Vận chuyển";
    public static final String STATUS_DELIVERING = "Giao hàng";
    public static final String STATUS_DELIVERED = "Đã giao";
    public static final String STATUS_CANCELLED = "Đơn hàng hủy";
    public static final String STATUS_RETURNED = "Đơn hàng hoàn";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_id")
    private Integer orderId;

    @Column(name = "order_code", length = 30, nullable = false, unique = true)
    private String orderCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "recipient_name", length = 100, nullable = false)
    private String recipientName;

    @Column(length = 20, nullable = false)
    private String phone;

    @Column(name = "shipping_address", length = 255, nullable = false)
    private String shippingAddress;

    @Column(length = 500)
    private String note;

    @Column(name = "payment_method", length = 20, nullable = false)
    private String paymentMethod = "COD";

    @Column(name = "total_amount", precision = 10, scale = 2, nullable = false)
    private BigDecimal totalAmount;

    @Column(length = 50, nullable = false)
    private String status = STATUS_NEW;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt = new Date();

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt = new Date();

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<OrderDetail> details = new ArrayList<>();

    public Order() {}

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getRecipientName() { return recipientName; }
    public void setRecipientName(String recipientName) { this.recipientName = recipientName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public List<OrderDetail> getDetails() { return details; }
    public void setDetails(List<OrderDetail> details) { this.details = details; }

    public void addDetail(OrderDetail detail) {
        details.add(detail);
        detail.setOrder(this);
    }
}