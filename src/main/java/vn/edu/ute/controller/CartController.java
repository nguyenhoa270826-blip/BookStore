package vn.edu.ute.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.edu.ute.service.CartService;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    // Xem trang giỏ hàng
    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        model.addAttribute("cartItems", cartService.getCart(session).values());
        model.addAttribute("totalAmount", cartService.getTotalAmount(session));
        model.addAttribute("totalCount", cartService.getTotalCount(session));
        return "cart";
    }

    // Thêm sản phẩm vào giỏ hàng
    @PostMapping("/add")
    public String addToCart(@RequestParam("bookId") Integer bookId,
                            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        String error = cartService.addToCart(session, bookId, quantity);
        if (error != null) {
            redirectAttributes.addFlashAttribute("errorMessage", error);
        } else {
            redirectAttributes.addFlashAttribute("successMessage", "Đã thêm sách vào giỏ hàng thành công!");
        }
        return "redirect:/cart";
    }

    // Cập nhật số lượng sản phẩm trong giới hạn
    @PostMapping("/update")
    public String updateQuantity(@RequestParam("bookId") Integer bookId,
                                 @RequestParam("quantity") int quantity,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        String warn = cartService.updateQuantity(session, bookId, quantity);
        if (warn != null) {
            redirectAttributes.addFlashAttribute("warningMessage", warn);
        }
        return "redirect:/cart";
    }

    // Xóa sản phẩm khỏi giỏ
    @GetMapping("/remove/{bookId}")
    public String removeItem(@PathVariable("bookId") Integer bookId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        cartService.removeItem(session, bookId);
        redirectAttributes.addFlashAttribute("successMessage", "Đã xóa sản phẩm khỏi giỏ hàng!");
        return "redirect:/cart";
    }

    // Xóa toàn bộ giỏ
    @GetMapping("/clear")
    public String clearCart(HttpSession session) {
        cartService.clearCart(session);
        return "redirect:/cart";
    }
}