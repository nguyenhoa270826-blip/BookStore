<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Giỏ Hàng - BookStore</title>
</head>
<body>
    <div class="container my-4">
        <h3 class="fw-bold mb-3"><i class="bi bi-cart3 me-2"></i>Giỏ Hàng Của Bạn</h3>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty warningMessage}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-1"></i>${warningMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="text-center py-5 bg-white rounded shadow-sm">
                    <i class="bi bi-cart-x text-muted" style="font-size: 3rem;"></i>
                    <h5 class="mt-3 text-muted">Giỏ hàng của bạn đang trống!</h5>
                    <a href="<c:url value='/home'/>" class="btn btn-primary mt-2">
                        <i class="bi bi-arrow-left me-1"></i>Khám phá sách ngay
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-lg-8">
                        <div class="table-responsive bg-white rounded shadow-sm p-3">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Sách</th>
                                        <th>Đơn Giá</th>
                                        <th>Số Lượng (Kho: Giới hạn)</th>
                                        <th>Thành Tiền</th>
                                        <th>Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cartItems}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${item.coverImage}" class="rounded me-3 border" style="width: 50px; height: 65px; object-fit: cover;">
                                                    <div>
                                                        <h6 class="mb-0 fw-bold">${item.title}</h6>
                                                        <small class="text-muted">Còn trong kho: ${item.maxStock} cuốn</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><fmt:formatNumber value="${item.price}" pattern="#,###"/> VNĐ</td>
                                            <td style="width: 170px;">
                                                <!-- Form thay đổi số lượng trong giới hạn -->
                                                <form action="<c:url value='/cart/update'/>" method="post" class="d-flex align-items-center">
                                                    <input type="hidden" name="bookId" value="${item.bookid}">
                                                    <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.maxStock}" 
                                                           class="form-control form-control-sm text-center me-1" style="width: 70px;"
                                                           onchange="this.form.submit()">
                                                    <button type="submit" class="btn btn-sm btn-outline-secondary" title="Cập nhật"><i class="bi bi-arrow-repeat"></i></button>
                                                </form>
                                            </td>
                                            <td class="fw-bold text-primary"><fmt:formatNumber value="${item.subtotal}" pattern="#,###"/> VNĐ</td>
                                            <td>
                                                <a href="<c:url value='/cart/remove/${item.bookid}'/>" class="btn btn-sm btn-outline-danger" title="Xóa khỏi giỏ">
                                                    <i class="bi bi-trash"></i> Xóa
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <div class="d-flex justify-content-between mt-3">
                                <a href="<c:url value='/home'/>" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>Tiếp tục mua sách
                                </a>
                                <a href="<c:url value='/cart/clear'/>" class="btn btn-outline-danger" onclick="return confirm('Bạn chắc chắn muốn xóa toàn bộ giỏ hàng?');">
                                    <i class="bi bi-trash3 me-1"></i>Xóa sạch giỏ hàng
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Tóm tắt thanh toán COD -->
                    <div class="col-lg-4 mt-4 mt-lg-0">
                        <div class="card shadow-sm border-0 p-3">
                            <h5 class="fw-bold border-bottom pb-2">Tóm Tắt Đơn Hàng</h5>
                            <div class="d-flex justify-content-between my-2">
                                <span>Tổng số lượng sách:</span>
                                <span class="fw-bold">${totalCount} cuốn</span>
                            </div>
                            <div class="d-flex justify-content-between my-2">
                                <span>Phương thức thanh toán:</span>
                                <span class="badge bg-success">COD (Tiền mặt)</span>
                            </div>
                            <div class="d-flex justify-content-between my-2">
                                <span>Phí vận chuyển:</span>
                                <span class="text-success fw-bold">Miễn phí (COD)</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between my-2 fs-5">
                                <span class="fw-bold">Tổng thanh toán:</span>
                                <span class="fw-bold text-danger"><fmt:formatNumber value="${totalAmount}" pattern="#,###"/> VNĐ</span>
                            </div>
                            <a href="<c:url value='/checkout'/>" class="btn btn-primary btn-lg w-100 fw-bold mt-3">
                                <i class="bi bi-cash-stack me-1"></i>Thanh Toán Bằng COD
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>