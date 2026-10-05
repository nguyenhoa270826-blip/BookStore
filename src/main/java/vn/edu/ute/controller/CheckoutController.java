package vn.edu.ute.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.edu.ute.entity.Order;
import vn.edu.ute.entity.User;
import vn.edu.ute.service.CartService;
import vn.edu.ute.service.OrderService;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    @Autowired
    private CartService cartService;

    @Autowired
    private OrderService orderService;

    // Xem trang thanh toán COD
    @GetMapping
    public String checkoutView(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (cartService.getCart(session).isEmpty()) {
            return "redirect:/cart";
        }

        model.addAttribute("user", user);
        model.addAttribute("cartItems", cartService.getCart(session).values());
        model.addAttribute("totalAmount", cartService.getTotalAmount(session));
        return "checkout";
    }

    // Xử lý xác nhận đặt hàng bằng COD
    @PostMapping("/cod")
    public String processCODOrder(@RequestParam("recipientName") String recipientName,
                                 @RequestParam("phone") String phone,
                                 @RequestParam("shippingAddress") String shippingAddress,
                                 @RequestParam(value = "note", required = false) String note,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            Order order = orderService.createCODOrder(
                user, recipientName, phone, shippingAddress, note,
                cartService.getCart(session)
            );

            // Làm rỗng giỏ hàng sau khi đặt thành công
            cartService.clearCart(session);

            redirectAttributes.addFlashAttribute("orderSuccess", true);
            redirectAttributes.addFlashAttribute("orderCode", order.getOrderCode());
            return "redirect:/orders/" + order.getOrderId();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/checkout";
        }
    }
}