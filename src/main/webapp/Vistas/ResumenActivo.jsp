<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Resumen de Activos</title>
        <!-- Bootstrap 5.3 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Iconos de Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/nav/navbar.jsp"></jsp:include>
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="text-primary"><i class="bi bi-bar-chart-fill"></i> Resumen de Activos</h1>
                <a href="${pageContext.request.contextPath}/ControladorActivo" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left-circle-fill"></i> Volver
                </a>
            </div>
            <hr>
            <!-- Tabla Resumen de Activos -->
            <table class="table table-striped table-hover table-bordered">
                <thead class="table-primary">
                    <tr>
                        <th>Familia de Activos</th>
                        <th class="text-center">Cantidad de Activos</th>
                        <th class="text-end">Total en Dinero</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="resumen" items="${resumenActivos}">
                        <tr>
                            <td>${resumen.familiaActivos}</td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${resumen.cantidadActivos != null}">
                                        ${resumen.cantidadActivos}
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <fmt:formatNumber value="${resumen.totalDinero}" type="currency" currencySymbol="$"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
