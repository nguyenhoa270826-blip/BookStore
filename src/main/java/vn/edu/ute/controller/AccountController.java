package vn.edu.ute.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.ute.entity.User;
import vn.edu.ute.service.UserService;

import java.util.Optional;

@Controller
public class AccountController {

    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "registered", required = false) Boolean registered, Model model) {
        if (Boolean.TRUE.equals(registered)) {
            model.addAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
        }
        return "login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam("email") String email,
                          @RequestParam("passwd") String passwd,
                          HttpSession session,
                          Model model) {
        Optional<User> userOpt = userService.login(email, passwd);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            session.setAttribute("user", user);
            session.setAttribute("isAdmin", user.getIsAdmin() != null && user.getIsAdmin());
            if (Boolean.TRUE.equals(user.getIsAdmin())) {
                return "redirect:/admin/books";
            }
            return "redirect:/home";
        }
        model.addAttribute("error", "Email hoặc mật khẩu không chính xác!");
        return "login";
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping("/register")
    public String doRegister(@ModelAttribute("user") User user, Model model) {
        try {
            userService.register(user);
            return "redirect:/login?registered=true";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}