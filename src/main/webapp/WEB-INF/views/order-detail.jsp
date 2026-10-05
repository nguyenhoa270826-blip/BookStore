<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi Tiết Đơn Hàng ${order.orderCode} - BookStore</title>
</head>
<body>
    <div class="container my-4">
        <a href="<c:url value='/orders'/>" class="btn btn-sm btn-outline-secondary mb-3">
            <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách đơn hàng
        </a>

        <div class="card shadow-sm border-0 p-4 mb-4">
            <div class="d-flex justify-content-between align-items-center border-bottom pb-3">
                <div>
                    <h4 class="fw-bold mb-0">Đơn Hàng #${order.orderCode}</h4>
                    <small class="text-muted">Ngày đặt: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></small>
                </div>
                <div>
                    <span class="badge fs-6 
                        ${order.status == 'Đơn hàng mới' ? 'bg-primary' : ''}
                        ${order.status == 'Đã xác nhận' ? 'bg-info text-dark' : ''}
                        ${order.status == 'Chuẩn bị hàng' ? 'bg-warning text-dark' : ''}
                        ${order.status == 'Vận chuyển' ? 'bg-secondary' : ''}
                        ${order.status == 'Giao hàng' ? 'bg-primary' : ''}
                        ${order.status == 'Đã giao' ? 'bg-success' : ''}
                        ${order.status == 'Đơn hàng hủy' ? 'bg-danger' : ''}
                        ${order.status == 'Đơn hàng hoàn' ? 'bg-dark' : ''}">
                        ${order.status}
                    </span>
                </div>
            </div>

            <!-- THÔNG TIN GIAO HÀNG & COD -->
            <div class="row mt-3">
                <div class="col-md-6">
                    <h6 class="fw-bold text-primary">Thông Tin Giao Hàng</h6>
                    <p class="mb-1"><strong>Người nhận:</strong> ${order.recipientName}</p>
                    <p class="mb-1"><strong>Số điện thoại:</strong> ${order.phone}</p>
                    <p class="mb-1"><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                    <c:if test="${not empty order.note}">
                        <p class="mb-1 text-muted"><strong>Ghi chú:</strong> ${order.note}</p>
                    </c:if>
                </div>
                <div class="col-md-6">
                    <h6 class="fw-bold text-primary">Thanh Toán & Cập Nhật</h6>
                    <p class="mb-1"><strong>Phương thức:</strong> <span class="badge bg-success">${order.paymentMethod} (Thanh toán tiền mặt khi nhận hàng)</span></p>
                    <p class="mb-1"><strong>Cập nhật gần nhất:</strong> <fmt:formatDate value="${order.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                    <p class="mb-1"><strong>Tổng số tiền COD:</strong> <span class="fs-5 fw-bold text-danger"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> VNĐ</span></p>
                </div>
            </div>

            <!-- DANH SÁCH MẶT HÀNG -->
            <h6 class="fw-bold text-primary mt-4 mb-2">Các Cuốn Sách Đã Đặt</h6>
            <div class="table-responsive">
                <table class="table table-bordered align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Sách</th>
                            <th>Đơn Giá</th>
                            <th>Số Lượng</th>
                            <th>Thành Tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${order.details}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${d.book.coverImage}" class="rounded me-2 border" style="width: 45px; height: 60px; object-fit: cover;">
                                        <div>
                                            <strong>${d.book.title}</strong>
                                            <div class="text-muted small">ISBN: ${d.book.isbn}</div>
                                        </div>
                                    </div>
                                </td>
                                <td><fmt:formatNumber value="${d.price}" pattern="#,###"/> VNĐ</td>
                                <td>${d.quantity}</td>
                                <td class="fw-bold text-primary"><fmt:formatNumber value="${d.subtotal}" pattern="#,###"/> VNĐ</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- KHỐI MÔ PHỎNG DATABASE ĐỔI TRẠNG THÁI (ĐỀ BÀI YÊU CẦU ĐỂ QUAN SÁT) -->
            <div class="bg-light p-3 rounded border mt-3">
                <h6 class="fw-bold text-secondary mb-2"><i class="bi bi-database me-1"></i>Thao tác Database: Mô phỏng đổi trạng thái để quan sát</h6>
                <form action="<c:url value='/orders/simulate-status/${order.orderId}'/>" method="post" class="row g-2 align-items-center">
                    <div class="col-auto">
                        <label class="col-form-label">Chọn trạng thái mới:</label>
                    </div>
                    <div class="col-auto">
                        <select name="newStatus" class="form-select form-select-sm">
                            <option value="Đơn hàng mới" ${order.status == 'Đơn hàng mới' ? 'selected' : ''}>1. Đơn hàng mới</option>
                            <option value="Đã xác nhận" ${order.status == 'Đã xác nhận' ? 'selected' : ''}>2. Đã xác nhận</option>
                            <option value="Chuẩn bị hàng" ${order.status == 'Chuẩn bị hàng' ? 'selected' : ''}>3. Chuẩn bị hàng</option>
                            <option value="Vận chuyển" ${order.status == 'Vận chuyển' ? 'selected' : ''}>4. Vận chuyển</option>
                            <option value="Giao hàng" ${order.status == 'Giao hàng' ? 'selected' : ''}>5. Giao hàng</option>
                            <option value="Đã giao" ${order.status == 'Đã giao' ? 'selected' : ''}>6. Đã giao</option>
                            <option value="Đơn hàng hủy" ${order.status == 'Đơn hàng hủy' ? 'selected' : ''}>7. Đơn hàng hủy</option>
                            <option value="Đơn hàng hoàn" ${order.status == 'Đơn hàng hoàn' ? 'selected' : ''}>8. Đơn hàng hoàn</option>
                        </select>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-warning btn-sm fw-bold">Cập nhật vào DB</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>