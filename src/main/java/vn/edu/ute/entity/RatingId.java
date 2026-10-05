package vn.edu.ute.entity;

import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class RatingId implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer userid;
    private Integer bookid;

    public RatingId() {}

    public RatingId(Integer userid, Integer bookid) {
        this.userid = userid;
        this.bookid = bookid;
    }

    public Integer getUserid() { return userid; }
    public void setUserid(Integer userid) { this.userid = userid; }

    public Integer getBookid() { return bookid; }
    public void setBookid(Integer bookid) { this.bookid = bookid; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RatingId)) return false;
        RatingId that = (RatingId) o;
        return Objects.equals(userid, that.userid) && Objects.equals(bookid, that.bookid);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userid, bookid);
    }
}