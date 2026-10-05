package vn.edu.ute.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.edu.ute.entity.Book;
import vn.edu.ute.repository.BookRepository;
import vn.edu.ute.repository.RatingRepository;

import java.util.List;
import java.util.Optional;

@Service
public class BookService {

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private RatingRepository ratingRepository;

    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    public Page<Book> getBooksPaginated(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("bookid").descending());
        return bookRepository.findAll(pageable);
    }

    public Optional<Book> getBookById(Integer id) {
        return bookRepository.findById(id);
    }

    @Transactional
    public Book saveBook(Book book) {
        return bookRepository.save(book);
    }

    @Transactional
    public void deleteBook(Integer id) {
        bookRepository.deleteById(id);
    }

    public long getReviewCount(Integer bookid) {
        return ratingRepository.countByBook_Bookid(bookid);
    }
}