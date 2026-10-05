<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch Sử Đặt Hàng - BookStore</title>
</head>
<body>
    <div class="container my-4">
        <h3 class="fw-bold mb-3"><i class="bi bi-clock-history me-2"></i>Lịch Sử Đặt Hàng</h3>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show">${successMessage}</div>
        </c:if>

        <!-- THANH LỌC 8 TRẠNG THÁI THEO ĐÚNG YÊU CẦU ĐỀ BÀI -->
        <ul class="nav nav-pills flex-wrap mb-4 bg-white p-2 rounded shadow-sm">
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'ALL' ? 'active' : ''}" href="<c:url value='/orders?status=ALL'/>">
                    Tất cả <span class="badge bg-secondary ms-1">${countAll}</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'Đơn hàng mới' ? 'active' : ''}" href="<c:url value='/orders?status=Đơn hàng mới'/>">
                    Đơn hàng mới <span class="badge bg-primary ms-1">${countNew}</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'Đã xác nhận' ? 'active' : ''}" href="<c:url value='/orders?status=Đã xác nhận'/>">
                    Đã xác nhận <span class="badge bg-info text-dark ms-1">${countConfirmed}</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'Chuẩn bị hàng' ? 'active' : ''}" href="<c:url value='/orders?status=Chuẩn bị hàng'/>">
                    Chuẩn bị hàng <span class="badge bg-warning text-dark ms-1">${countPreparing}</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'Vận chuyển' ? 'active' : ''}" href="<c:url value='/orders?status=Vận chuyển'/>">
                    Vận chuyển <span class="badge bg-secondary ms-1">${countShipping}</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'Giao hàng' ? 'active' : ''}" href="<c:url value='/orders?status=Giao hàng'/>">
                    Giao hàng <span class="badge bg-primary ms-1">${countDelivering}</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'Đã giao' ? 'active' : ''}" href="<c:url value='/orders?status=Đã giao'/>">
                    Đã giao <span class="badge bg-success ms-1">${countDelivered}</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'Đơn hàng hủy' ? 'active' : ''}" href="<c:url value='/orders?status=Đơn hàng hủy'/>">
                    Đơn hàng hủy <span class="badge bg-danger ms-1">${countCancelled}</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 'Đơn hàng hoàn' ? 'active' : ''}" href="<c:url value='/orders?status=Đơn hàng hoàn'/>">
                    Đơn hàng hoàn <span class="badge bg-dark ms-1">${countReturned}</span>
                </a>
            </li>
        </ul>

        <!-- DANH SÁCH ĐƠN HÀNG -->
        <c:choose>
            <c:when test="${empty orders}">
                <div class="text-center py-5 bg-white rounded shadow-sm">
                    <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                    <h5 class="mt-3 text-muted">Không có đơn hàng nào ở trạng thái này!</h5>
                </div>
            </c:when>
            <c:otherwise>
                <div class="space-y-3">
                    <c:forEach var="o" items="${orders}">
                        <div class="card shadow-sm border-0 mb-3">
                            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>Mã đơn: ${o.orderCode}</strong>
                                    <span class="text-muted ms-3"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                </div>
                                <div>
                                    <span class="badge 
                                        ${o.status == 'Đơn hàng mới' ? 'bg-primary' : ''}
                                        ${o.status == 'Đã xác nhận' ? 'bg-info text-dark' : ''}
                                        ${o.status == 'Chuẩn bị hàng' ? 'bg-warning text-dark' : ''}
                                        ${o.status == 'Vận chuyển' ? 'bg-secondary' : ''}
                                        ${o.status == 'Giao hàng' ? 'bg-indigo text-white' : ''}
                                        ${o.status == 'Đã giao' ? 'bg-success' : ''}
                                        ${o.status == 'Đơn hàng hủy' ? 'bg-danger' : ''}
                                        ${o.status == 'Đơn hàng hoàn' ? 'bg-dark' : ''}">
                                        ${o.status}
                                    </span>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <p class="mb-1"><strong>Người nhận:</strong> ${o.recipientName} - ${o.phone}</p>
                                        <p class="mb-1 text-muted"><i class="bi bi-geo-alt"></i> ${o.shippingAddress}</p>
                                        <p class="mb-0"><span class="badge bg-success">Phương thức: ${o.paymentMethod} (Thanh toán khi nhận)</span></p>
                                    </div>
                                    <div class="col-md-4 text-md-end mt-3 mt-md-0">
                                        <h5 class="fw-bold text-danger mb-2">Tổng tiền: <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/> VNĐ</h5>
                                        <a href="<c:url value='/orders/${o.orderId}'/>" class="btn btn-outline-primary btn-sm">
                                            Xem chi tiết <i class="bi bi-chevron-right"></i>
                                        </a>
                                        <c:if test="${o.status == 'Đơn hàng mới'}">
                                            <form action="<c:url value='/orders/cancel/${o.orderId}'/>" method="post" class="d-inline" onsubmit="return confirm('Bạn chắc chắn muốn hủy đơn hàng này?');">
                                                <button type="submit" class="btn btn-outline-danger btn-sm ms-1">Hủy đơn</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>