package vn.edu.ute.service;

import org.springframework.stereotype.Service;

@Service
public class EmailService {
    // Thông tin tài khoản email từ đề bài
    private static final String FROM_EMAIL = "nguyenhoa270826@gmail.com";
    private static final String FROM_PASSWORD = "zngp xqch bnsb cbxd";

    public void sendWelcomeEmail(String toEmail, String fullname) {
        System.out.println("Gửi email chào mừng từ " + FROM_EMAIL + " đến " + toEmail + " (" + fullname + ")");
    }

    public void sendOrderConfirmationEmail(String toEmail, String orderCode, String totalAmount) {
        System.out.println("Gửi email xác nhận đơn hàng " + orderCode + " (" + totalAmount + ") từ " + FROM_EMAIL + " đến " + toEmail);
    }
}