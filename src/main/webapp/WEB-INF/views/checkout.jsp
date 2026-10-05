<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh Toán Đơn Hàng (COD) - BookStore</title>
</head>
<body>
    <div class="container my-4">
        <h3 class="fw-bold mb-3"><i class="bi bi-truck me-2"></i>Thanh Toán Đơn Hàng Bằng COD</h3>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <form action="<c:url value='/checkout/cod'/>" method="post">
            <div class="row">
                <!-- Thông tin người nhận -->
                <div class="col-lg-7">
                    <div class="card shadow-sm border-0 p-4 mb-4">
                        <h5 class="fw-bold text-primary mb-3">1. Thông Tin Nhận Hàng</h5>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Họ tên người nhận: *</label>
                            <input type="text" name="recipientName" class="form-control" value="${user.fullname}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Số điện thoại liên hệ: *</label>
                            <input type="text" name="phone" class="form-control" value="${user.phone}" required placeholder="VD: 0912345678">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Địa chỉ giao hàng chi tiết: *</label>
                            <textarea name="shippingAddress" class="form-control" rows="2" required placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Ghi chú cho Shipper (tuỳ chọn):</label>
                            <input type="text" name="note" class="form-control" placeholder="Giao giờ hành chính, gọi trước 15p...">
                        </div>
                    </div>

                    <div class="card shadow-sm border-0 p-4">
                        <h5 class="fw-bold text-primary mb-3">2. Phương Thức Thanh Toán</h5>
                        <div class="form-check p-3 border rounded bg-light border-primary">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="codPayment" value="COD" checked>
                            <label class="form-check-label fw-bold d-block" for="codPayment">
                                <i class="bi bi-cash-coin me-1 text-success"></i> COD (Thanh toán tiền mặt khi nhận hàng)
                            </label>
                            <small class="text-muted d-block mt-1">
                                Bạn chỉ phải trả tiền khi bưu tá giao sách tận tay. Đảm bảo kiểm tra sách trước khi thanh toán.
                            </small>
                        </div>
                    </div>
                </div>

                <!-- Tóm tắt đơn hàng -->
                <div class="col-lg-5 mt-4 mt-lg-0">
                    <div class="card shadow-sm border-0 p-4">
                        <h5 class="fw-bold mb-3">Đơn Hàng Của Bạn</h5>
                        <ul class="list-group list-group-flush mb-3">
                            <c:forEach var="item" items="${cartItems}">
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <div>
                                        <h6 class="my-0">${item.title}</h6>
                                        <small class="text-muted">SL: ${item.quantity} x <fmt:formatNumber value="${item.price}" pattern="#,###"/> VNĐ</small>
                                    </div>
                                    <span class="text-primary fw-bold"><fmt:formatNumber value="${item.subtotal}" pattern="#,###"/> VNĐ</span>
                                </li>
                            </c:forEach>
                        </ul>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Phí vận chuyển COD:</span>
                            <span class="text-success fw-bold">Miễn phí</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-3 fs-5">
                            <span class="fw-bold">Tổng thanh toán:</span>
                            <span class="fw-bold text-danger"><fmt:formatNumber value="${totalAmount}" pattern="#,###"/> VNĐ</span>
                        </div>
                        <button type="submit" class="btn btn-success btn-lg w-100 fw-bold">
                            <i class="bi bi-check2-circle me-1"></i>Xác Nhận Đặt Hàng COD
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</body>
</html>