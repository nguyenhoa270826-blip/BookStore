package vn.edu.ute.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import vn.edu.ute.entity.Book;
import vn.edu.ute.service.BookService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    @Autowired
    private BookService bookService;

    @GetMapping({"/", "/home", "/books"})
    public String home(Model model) {
        List<Book> books = bookService.getAllBooks();
        Map<Integer, Long> reviewCounts = new HashMap<>();
        for (Book b : books) {
            reviewCounts.put(b.getBookid(), bookService.getReviewCount(b.getBookid()));
        }
        model.addAttribute("books", books);
        model.addAttribute("reviewCounts", reviewCounts);
        return "home";
    }
}