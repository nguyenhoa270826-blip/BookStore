package vn.edu.ute.model;

import vn.edu.ute.entity.Book;
import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer bookid;
    private String title;
    private BigDecimal price;
    private String coverImage;
    private Integer quantity;
    private Integer maxStock; // Số lượng tồn kho tối đa

    public CartItem() {}

    public CartItem(Book book, Integer quantity) {
        this.bookid = book.getBookid();
        this.title = book.getTitle();
        this.price = book.getPrice();
        this.coverImage = book.getCoverImage();
        this.quantity = quantity;
        this.maxStock = book.getQuantity() != null ? book.getQuantity() : 0;
    }

    public BigDecimal getSubtotal() {
        if (price == null || quantity == null) return BigDecimal.ZERO;
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    public Integer getBookid() { return bookid; }
    public void setBookid(Integer bookid) { this.bookid = bookid; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Integer getMaxStock() { return maxStock; }
    public void setMaxStock(Integer maxStock) { this.maxStock = maxStock; }
}