package vn.edu.ute.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "rating")
public class Rating implements Serializable {
    private static final long serialVersionUID = 1L;

    @EmbeddedId
    private RatingId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userid")
    @JoinColumn(name = "userid")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("bookid")
    @JoinColumn(name = "bookid")
    private Book book;

    private Short rating;

    @Column(name = "review_text", columnDefinition = "TEXT")
    private String reviewText;

    public Rating() {}

    public RatingId getId() { return id; }
    public void setId(RatingId id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }

    public Short getRating() { return rating; }
    public void setRating(Short rating) { this.rating = rating; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }
}