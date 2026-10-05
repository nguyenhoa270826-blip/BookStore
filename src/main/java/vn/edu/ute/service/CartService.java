package vn.edu.ute.service;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vn.edu.ute.entity.Book;
import vn.edu.ute.model.CartItem;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
public class CartService {

    public static final String SESSION_CART_KEY = "CART";

    @Autowired
    private BookService bookService;

    @SuppressWarnings("unchecked")
    public Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute(SESSION_CART_KEY);
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute(SESSION_CART_KEY, cart);
        }
        return cart;
    }

    /**
     * Thêm sách vào giỏ: kiểm tra tồn kho trong giới hạn
     */
    public String addToCart(HttpSession session, Integer bookId, int quantity) {
        Optional<Book> bookOpt = bookService.getBookById(bookId);
        if (bookOpt.isEmpty()) {
            return "Không tìm thấy cuốn sách yêu cầu!";
        }
        Book book = bookOpt.get();
        int availableStock = book.getQuantity() != null ? book.getQuantity() : 0;
        if (availableStock <= 0) {
            return "Sách này hiện đã hết hàng trong kho!";
        }

        Map<Integer, CartItem> cart = getCart(session);
        CartItem item = cart.get(bookId);

        int targetQty = quantity;
        if (item != null) {
            targetQty = item.getQuantity() + quantity;
        }

        if (targetQty > availableStock) {
            return "Số lượng yêu cầu vượt quá giới hạn tồn kho (Hiện còn: " + availableStock + " cuốn)!";
        }

        if (item == null) {
            item = new CartItem(book, targetQty);
            cart.put(bookId, item);
        } else {
            item.setQuantity(targetQty);
            item.setMaxStock(availableStock);
        }

        session.setAttribute(SESSION_CART_KEY, cart);
        return null; // Thành công
    }

    /**
     * Thay đổi số lượng sách trong giới hạn: tối thiểu 1, tối đa tồn kho
     */
    public String updateQuantity(HttpSession session, Integer bookId, int newQuantity) {
        if (newQuantity <= 0) {
            removeItem(session, bookId);
            return null;
        }

        Map<Integer, CartItem> cart = getCart(session);
        CartItem item = cart.get(bookId);
        if (item == null) return "Sách không có trong giỏ hàng!";

        Optional<Book> bookOpt = bookService.getBookById(bookId);
        int availableStock = bookOpt.map(b -> b.getQuantity() != null ? b.getQuantity() : 0).orElse(item.getMaxStock());

        if (newQuantity > availableStock) {
            item.setQuantity(availableStock);
            session.setAttribute(SESSION_CART_KEY, cart);
            return "Chỉ có thể cập nhật tối đa " + availableStock + " cuốn theo tồn kho hiện tại!";
        }

        item.setQuantity(newQuantity);
        item.setMaxStock(availableStock);
        session.setAttribute(SESSION_CART_KEY, cart);
        return null;
    }

    public void removeItem(HttpSession session, Integer bookId) {
        Map<Integer, CartItem> cart = getCart(session);
        cart.remove(bookId);
        session.setAttribute(SESSION_CART_KEY, cart);
    }

    public void clearCart(HttpSession session) {
        session.removeAttribute(SESSION_CART_KEY);
    }

    public BigDecimal getTotalAmount(HttpSession session) {
        Map<Integer, CartItem> cart = getCart(session);
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart.values()) {
            total = total.add(item.getSubtotal());
        }
        return total;
    }

    public int getTotalCount(HttpSession session) {
        Map<Integer, CartItem> cart = getCart(session);
        int count = 0;
        for (CartItem item : cart.values()) {
            count += item.getQuantity();
        }
        return count;
    }
}