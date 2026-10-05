-- =======================================================
-- ĐỀ THI QUÁ TRÌNH HK1 - MÔN LẬP TRÌNH WEB
-- Họ và tên sinh viên: Nguyễn Thị Hoa - MSSV: 24133018
-- Database: SQL Server (sa / 123456) - Database Name: BookStoreDB
-- Email: nguyenhoa270826@gmail.com / zngp xqch bnsb cbxd
-- Đơn vị tiền tệ: VNĐ (Việt Nam Đồng)
-- =======================================================

USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BookStoreDB')
BEGIN
    CREATE DATABASE BookStoreDB;
END
GO

USE BookStoreDB;
GO

-- Xóa bảng cũ theo thứ tự khóa ngoại
IF OBJECT_ID('dbo.order_details', 'U') IS NOT NULL DROP TABLE dbo.order_details;
IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL DROP TABLE dbo.orders;
IF OBJECT_ID('dbo.rating', 'U') IS NOT NULL DROP TABLE dbo.rating;
IF OBJECT_ID('dbo.book_author', 'U') IS NOT NULL DROP TABLE dbo.book_author;
IF OBJECT_ID('dbo.books', 'U') IS NOT NULL DROP TABLE dbo.books;
IF OBJECT_ID('dbo.author', 'U') IS NOT NULL DROP TABLE dbo.author;
IF OBJECT_ID('dbo.users', 'U') IS NOT NULL DROP TABLE dbo.users;
GO

-- 1. Bảng users
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(50) NOT NULL UNIQUE,
    fullname NVARCHAR(50) NOT NULL,
    phone INT NULL,
    passwd VARCHAR(32) NOT NULL,
    signup_date DATETIME DEFAULT GETDATE(),
    last_login DATETIME NULL,
    is_admin BIT DEFAULT 0
);
GO

-- 2. Bảng books (Đơn giá tính theo VNĐ)
CREATE TABLE books (
    bookid INT IDENTITY(1,1) PRIMARY KEY,
    isbn INT NOT NULL,
    title NVARCHAR(200) NOT NULL,
    publisher NVARCHAR(100) NULL,
    price DECIMAL(12, 0) NULL,
    description NVARCHAR(MAX) NULL,
    publish_date DATE NULL,
    cover_image VARCHAR(255) NULL,
    quantity INT DEFAULT 0
);
GO

-- 3. Bảng author
CREATE TABLE author (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(100) NOT NULL,
    date_of_birth DATE NULL
);
GO

-- 4. Bảng book_author
CREATE TABLE book_author (
    bookid INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (bookid, author_id),
    FOREIGN KEY (bookid) REFERENCES books(bookid) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);
GO

-- 5. Bảng rating
CREATE TABLE rating (
    rating_id INT IDENTITY(1,1) PRIMARY KEY,
    userid INT NOT NULL,
    bookid INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text NVARCHAR(MAX) NULL,
    review_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userid) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (bookid) REFERENCES books(bookid) ON DELETE CASCADE
);
GO

-- 6. Bảng orders (Hỗ trợ 8 trạng thái và thanh toán COD)
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_code VARCHAR(30) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    recipient_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    shipping_address NVARCHAR(255) NOT NULL,
    note NVARCHAR(255) NULL,
    payment_method VARCHAR(20) DEFAULT 'COD',
    total_amount DECIMAL(12, 0) NOT NULL,
    status NVARCHAR(50) NOT NULL DEFAULT N'Đơn hàng mới',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
GO

-- 7. Bảng order_details
CREATE TABLE order_details (
    detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(12, 0) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(12, 0) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(bookid) ON DELETE CASCADE
);
GO

-- =======================================================
-- CHÈN DỮ LIỆU MẪU
-- =======================================================

-- Users (Mật khẩu: 123456)
INSERT INTO users (email, fullname, phone, passwd, signup_date, last_login, is_admin)
VALUES 
('admin@bookstore.vn', N'Nguyễn Thị Hoa (Admin)', 987654321, '123456', GETDATE(), GETDATE(), 1),
('user1@gmail.com', N'Trần Văn An', 912345678, '123456', GETDATE(), GETDATE(), 0),
('user2@gmail.com', N'Lê Thị Mai', 923456789, '123456', GETDATE(), GETDATE(), 0),
('nguyenhoa270826@gmail.com', N'Nguyễn Thị Hoa', 934567890, '123456', GETDATE(), GETDATE(), 0);

-- Authors
INSERT INTO author (author_name, date_of_birth)
VALUES 
('Robert C. Martin', '1952-12-05'),
('Joshua Bloch', '1961-08-28'),
('Martin Fowler', '1963-12-18'),
('Craig Walls', '1971-04-15'),
('Nguyễn Nhật Ánh', '1955-05-07'),
('Cay S. Horstmann', '1959-06-16');

-- Books (Tiền tệ VNĐ)
INSERT INTO books (isbn, title, publisher, price, description, publish_date, cover_image, quantity)
VALUES 
(97801323, 'Clean Code: A Handbook of Agile Software Craftsmanship', 'Prentice Hall', 250000, N'Clean Code hướng dẫn viết code rõ ràng, dễ bảo trì và mở rộng trong các dự án phần mềm lớn.', '2008-08-01', 'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400', 50),
(97801346, 'Effective Java 3rd Edition', 'Addison-Wesley', 280000, N'Cuốn sách kinh điển của Joshua Bloch về Best Practices trong ngôn ngữ lập trình Java hiện đại.', '2018-01-06', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400', 35),
(97801347, 'Spring in Action 6th Edition', 'Manning Publications', 320000, N'Hướng dẫn toàn diện về Spring Boot, Spring MVC, REST APIs và xây dựng ứng dụng Web quy mô lớn.', '2022-03-10', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400', 40),
(97802014, 'Refactoring: Improving the Design of Existing Code', 'Addison-Wesley', 230000, N'Kỹ thuật tái cấu trúc mã nguồn để cải thiện thiết kế mà không làm thay đổi hành vi bên ngoài.', '2018-11-20', 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400', 25),
(97860458, 'Mắt Biếc', N'NXB Trẻ', 110000, N'Tác phẩm văn học nổi tiếng đầy cảm xúc về tình yêu tuổi học trò của nhà văn Nguyễn Nhật Ánh.', '2019-09-15', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400', 80),
(97801351, 'Core Java Volume I – Fundamentals', 'Prentice Hall', 260000, N'Tài liệu chuẩn xác và chuyên sâu về nền tảng ngôn ngữ Java, OOP, Streams và thư viện chuẩn.', '2020-05-12', 'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=400', 30);

-- Book_Author
INSERT INTO book_author (bookid, author_id)
VALUES 
(1, 1),
(2, 2),
(3, 4),
(4, 3),
(5, 5),
(6, 6);

-- Rating
INSERT INTO rating (userid, bookid, rating, review_text)
VALUES 
(2, 1, 5, N'Sách cực kỳ bổ ích cho bất kỳ lập trình viên nào muốn nâng cao tư duy clean architecture.'),
(3, 1, 4, N'Đọc rất cuốn, nhiều ví dụ thực tế về đặt tên biến và tách hàm.'),
(1, 1, 5, N'Must-read cho các bạn sinh viên ngành Công nghệ Phần mềm.'),
(2, 2, 5, N'Một kiệt tác về Java, giải thích sâu sắc về Generics, Enums và Concurrency.'),
(3, 2, 5, N'Không thể thiếu trên bàn làm việc của Java Backend Developer.'),
(1, 3, 5, N'Rất dễ hiểu cho người mới học Spring Boot và JSP!'),
(2, 4, 4, N'Cải thiện cấu trúc mã nguồn rất hiệu quả sau khi đọc cuốn này.'),
(3, 5, 5, N'Một câu chuyện nhẹ nhàng, sâu lắng và đượm buồn.');

-- =======================================================
-- DỮ LIỆU ĐƠN HÀNG COD 8 TRẠNG THÁI (TIỀN TỆ VNĐ)
-- =======================================================

-- 1. Đơn 1: Đơn hàng mới
INSERT INTO orders (order_code, user_id, recipient_name, phone, shipping_address, note, payment_method, total_amount, status, created_at, updated_at)
VALUES ('ORD-2026-001', 2, N'Trần Văn An', '0912345678', N'Số 1 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức', N'Giao giờ hành chính', 'COD', 530000, N'Đơn hàng mới', DATEADD(MINUTE, -120, GETDATE()), GETDATE());

INSERT INTO order_details (order_id, book_id, price, quantity, subtotal)
VALUES 
(1, 1, 250000, 1, 250000),
(1, 2, 280000, 1, 280000);

-- 2. Đơn 2: Đã xác nhận
INSERT INTO orders (order_code, user_id, recipient_name, phone, shipping_address, note, payment_method, total_amount, status, created_at, updated_at)
VALUES ('ORD-2026-002', 2, N'Trần Văn An', '0912345678', N'Số 1 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức', N'Gọi trước khi giao 15 phút', 'COD', 320000, N'Đã xác nhận', DATEADD(HOUR, -6, GETDATE()), GETDATE());

INSERT INTO order_details (order_id, book_id, price, quantity, subtotal)
VALUES (2, 3, 320000, 1, 320000);

-- 3. Đơn 3: Chuẩn bị hàng
INSERT INTO orders (order_code, user_id, recipient_name, phone, shipping_address, note, payment_method, total_amount, status, created_at, updated_at)
VALUES ('ORD-2026-003', 2, N'Trần Văn An', '0912345678', N'Số 12 Đặng Văn Bi, Trường Thọ, TP. Thủ Đức', N'Đóng gói cẩn thận giúp mình', 'COD', 690000, N'Chuẩn bị hàng', DATEADD(HOUR, -12, GETDATE()), GETDATE());

INSERT INTO order_details (order_id, book_id, price, quantity, subtotal)
VALUES (3, 4, 230000, 3, 690000);

-- 4. Đơn 4: Vận chuyển
INSERT INTO orders (order_code, user_id, recipient_name, phone, shipping_address, note, payment_method, total_amount, status, created_at, updated_at)
VALUES ('ORD-2026-004', 2, N'Trần Văn An', '0912345678', N'Số 1 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức', N'Hàng hỏa tốc', 'COD', 250000, N'Vận chuyển', DATEADD(DAY, -1, GETDATE()), GETDATE());

INSERT INTO order_details (order_id, book_id, price, quantity, subtotal)
VALUES (4, 1, 250000, 1, 250000);

-- 5. Đơn 5: Giao hàng
INSERT INTO orders (order_code, user_id, recipient_name, phone, shipping_address, note, payment_method, total_amount, status, created_at, updated_at)
VALUES ('ORD-2026-005', 2, N'Trần Văn An', '0912345678', N'Ký túc xá khu B, ĐHQG TP.HCM', N'Giao cổng trước', 'COD', 220000, N'Giao hàng', DATEADD(DAY, -2, GETDATE()), GETDATE());

INSERT INTO order_details (order_id, book_id, price, quantity, subtotal)
VALUES (5, 5, 110000, 2, 220000);

-- 6. Đơn 6: Đã giao
INSERT INTO orders (order_code, user_id, recipient_name, phone, shipping_address, note, payment_method, total_amount, status, created_at, updated_at)
VALUES ('ORD-2026-006', 2, N'Trần Văn An', '0912345678', N'Số 1 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức', N'Đã thanh toán COD thành công', 'COD', 560000, N'Đã giao', DATEADD(DAY, -3, GETDATE()), GETDATE());

INSERT INTO order_details (order_id, book_id, price, quantity, subtotal)
VALUES (6, 2, 280000, 2, 560000);

-- 7. Đơn 7: Đơn hàng hủy
INSERT INTO orders (order_code, user_id, recipient_name, phone, shipping_address, note, payment_method, total_amount, status, created_at, updated_at)
VALUES ('ORD-2026-007', 2, N'Trần Văn An', '0912345678', N'Số 1 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức', N'Khách hàng đổi ý muốn đổi tựa sách khác', 'COD', 230000, N'Đơn hàng hủy', DATEADD(DAY, -4, GETDATE()), GETDATE());

INSERT INTO order_details (order_id, book_id, price, quantity, subtotal)
VALUES (7, 4, 230000, 1, 230000);

-- 8. Đơn 8: Đơn hàng hoàn
INSERT INTO orders (order_code, user_id, recipient_name, phone, shipping_address, note, payment_method, total_amount, status, created_at, updated_at)
VALUES ('ORD-2026-008', 2, N'Trần Văn An', '0912345678', N'Số 1 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức', N'Shipper liên hệ 3 lần không nghe máy, hoàn kho', 'COD', 320000, N'Đơn hàng hoàn', DATEADD(DAY, -5, GETDATE()), GETDATE());

INSERT INTO order_details (order_id, book_id, price, quantity, subtotal)
VALUES (8, 3, 320000, 1, 320000);
GO
