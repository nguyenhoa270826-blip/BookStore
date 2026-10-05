package vn.edu.ute.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.edu.ute.entity.Order;
import vn.edu.ute.entity.User;
import vn.edu.ute.service.OrderService;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // Xem lịch sử đặt hàng với bộ lọc 8 trạng thái
    @GetMapping
    public String orderHistory(@RequestParam(value = "status", required = false, defaultValue = "ALL") String status,
                               HttpSession session,
                               Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Order> orders = orderService.getOrdersByUser(user, status);
        model.addAttribute("orders", orders);
        model.addAttribute("currentStatus", status);

        // Đếm số lượng đơn ở từng trạng thái để hiển thị Badge
        model.addAttribute("countAll", orderService.countAllByUser(user));
        model.addAttribute("countNew", orderService.countByStatus(user, Order.STATUS_NEW));
        model.addAttribute("countConfirmed", orderService.countByStatus(user, Order.STATUS_CONFIRMED));
        model.addAttribute("countPreparing", orderService.countByStatus(user, Order.STATUS_PREPARING));
        model.addAttribute("countShipping", orderService.countByStatus(user, Order.STATUS_SHIPPING));
        model.addAttribute("countDelivering", orderService.countByStatus(user, Order.STATUS_DELIVERING));
        model.addAttribute("countDelivered", orderService.countByStatus(user, Order.STATUS_DELIVERED));
        model.addAttribute("countCancelled", orderService.countByStatus(user, Order.STATUS_CANCELLED));
        model.addAttribute("countReturned", orderService.countByStatus(user, Order.STATUS_RETURNED));

        return "order-history";
    }

    // Xem chi tiết đơn hàng
    @GetMapping("/{id}")
    public String orderDetail(@PathVariable("id") Integer id,
                              HttpSession session,
                              Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Optional<Order> orderOpt = orderService.getOrderById(id);
        if (orderOpt.isEmpty()) return "redirect:/orders";

        model.addAttribute("order", orderOpt.get());
        return "order-detail";
    }

    // Hủy đơn hàng (khi ở trạng thái "Đơn hàng mới")
    @PostMapping("/cancel/{id}")
    public String cancelOrder(@PathVariable("id") Integer id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        try {
            Optional<Order> orderOpt = orderService.getOrderById(id);
            if (orderOpt.isPresent() && Order.STATUS_NEW.equals(orderOpt.get().getStatus())) {
                orderService.updateOrderStatus(id, Order.STATUS_CANCELLED);
                redirectAttributes.addFlashAttribute("successMessage", "Đã hủy đơn hàng thành công!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Không thể hủy đơn hàng này!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/orders";
    }

    // Mô phỏng cập nhật trạng thái trong database (để quan sát trạng thái thay đổi theo yêu cầu đề bài)
    @PostMapping("/simulate-status/{id}")
    public String simulateStatusChange(@PathVariable("id") Integer id,
                                       @RequestParam("newStatus") String newStatus,
                                       RedirectAttributes redirectAttributes) {
        try {
            orderService.updateOrderStatus(id, newStatus);
            redirectAttributes.addFlashAttribute("successMessage", "Đã cập nhật đơn sang trạng thái: '" + newStatus + "'!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/orders/" + id;
    }
}