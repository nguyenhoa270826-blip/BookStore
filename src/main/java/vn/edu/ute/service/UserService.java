package vn.edu.ute.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.edu.ute.entity.User;
import vn.edu.ute.repository.UserRepository;

import java.util.Date;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

    public Optional<User> login(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmailAndPasswd(email, password);
        if (userOpt.isPresent()) {
            User u = userOpt.get();
            u.setLastLogin(new Date());
            userRepository.save(u);
        }
        return userOpt;
    }

    @Transactional
    public User register(User user) throws Exception {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new Exception("Email đã tồn tại trong hệ thống!");
        }
        user.setSignupDate(new Date());
        user.setIsAdmin(false);
        User saved = userRepository.save(user);
        
        try {
            emailService.sendWelcomeEmail(saved.getEmail(), saved.getFullname());
        } catch (Exception e) {
            // Không làm gián đoạn luồng
        }
        return saved;
    }

    public Optional<User> findById(Integer id) {
        return userRepository.findById(id);
    }
}