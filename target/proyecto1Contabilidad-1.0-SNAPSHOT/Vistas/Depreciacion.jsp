<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Depreciación del Activo</title>
        <!-- Bootstrap 5.3 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- Iconos de Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/nav/navbar.jsp"></jsp:include>
            <div class="container mt-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="text-success"><i class="bi bi-bar-chart-fill"></i> Resultados de la Depreciación</h1>
                    <a href="${pageContext.request.contextPath}/ControladorActivo" class="btn btn-outline-success">
                    <i class="bi bi-arrow-left-circle-fill"></i> Volver
                </a>
            </div>

            <h2>Depreciación Anual</h2>
            <!-- Tabla de Depreciación Anual -->
            <div class="table-responsive">
                <table id="tablaDepreciacion" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Año</th>
                            <th>Familia del Activo</th>
                            <th>Marca</th>
                            <th>Depreciación Anual</th>
                            <th>Depreciación Acumulada</th>
                            <th>Valor en Libro</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="depreciacion" items="${resultados}">
                            <tr>
                                <td><c:out value="${depreciacion.anio}"/></td>
                                <td><c:out value="${depreciacion.nombreactivofami}"/></td>
                                <td><c:out value="${depreciacion.marca}"/></td>
                                <td>
                                    <fmt:formatNumber value="${depreciacion.depreciacionAnual}" type="currency" currencySymbol="$"/>
                                </td> 
                                <td>
                                    <fmt:formatNumber value="${depreciacion.depreciacionAcumulada}" type="currency" currencySymbol="$"/>
                                </td> 
                                <td>
                                    <fmt:formatNumber value="${depreciacion.valorEnLibro}" type="currency" currencySymbol="$"/>
                                </td>  
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <br>
            <h2>Depreciación Mensual</h2>
            <!-- Tabla de Depreciación Mensual -->
            <div class="table-responsive">
                <table id="tablaDepreciacionMensual" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Mes</th>
                            <th>Familia del Activo</th>
                            <th>Marca</th>
                            <th>Depreciación Mensual</th>
                            <th>Depreciación Acumulada</th>
                            <th>Valor en Libro</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="depreciacionMensual" items="${resultadosMensuales}">
                            <tr>
                                <td><c:out value="${depreciacionMensual.mes}"/></td>
                                <td><c:out value="${depreciacionMensual.nombreactivofami}"/></td>
                                <td><c:out value="${depreciacionMensual.marca}"/></td>
                                <td>
                                    <fmt:formatNumber value="${depreciacionMensual.depreciacionMensual}" type="currency" currencySymbol="$"/>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${depreciacionMensual.depreciacionAcumulada}" type="currency" currencySymbol="$"/>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${depreciacionMensual.valorEnLibro}" type="currency" currencySymbol="$"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <br>
            <h2>Depreciación Diaria</h2>
            <!-- Tabla de Depreciación Diaria -->
            <div class="table-responsive">
                <table id="tablaDepreciacionDiaria" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Día</th>
                            <th>Familia del Activo</th>
                            <th>Marca</th>
                            <th>Depreciación Diaria</th>
                            <th>Depreciación Acumulada</th>
                            <th>Valor en Libro</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="depreciacionDiaria" items="${resultadosDiarios}">
                            <tr>
                                <td><c:out value="${depreciacionDiaria.dia}"/></td>
                                <td><c:out value="${depreciacionDiaria.nombreactivofami}"/></td>
                                <td><c:out value="${depreciacionDiaria.marca}"/></td>
                                <td>
                                    <fmt:formatNumber value="${depreciacionDiaria.depreciacionDiaria}" type="currency" currencySymbol="$"/>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${depreciacionDiaria.depreciacionAcumulada}" type="currency" currencySymbol="$"/>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${depreciacionDiaria.valorEnLibro}" type="currency" currencySymbol="$"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <br>
            <hr>

            <!-- Gráfica de Depreciación -->
            <div class="mt-5">
                <h2>Gráfica de Depreciación</h2>
                <canvas id="graficaDepreciacion"></canvas>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                // Inicializar DataTables
                $('#tablaDepreciacion').DataTable();
                $('#tablaDepreciacionMensual').DataTable({
                    "ordering": false
                });

                $('#tablaDepreciacionDiaria').DataTable({
                    "ordering": false
                });

                // Función para generar un color aleatorio en formato hexadecimal
                function getRandomColor() {
                    var letters = '0123456789ABCDEF';
                    var color = '#';
                    for (var i = 0; i < 6; i++) {
                        color += letters[Math.floor(Math.random() * 16)];
                    }
                    return color;
                }

                // Configuración de la gráfica
                var ctx = document.getElementById('graficaDepreciacion').getContext('2d');
                var datosGrafica = ${datosGrafica};

                var labels = datosGrafica.map(function (item) {
                    return item.fecha;
                });

                var data = datosGrafica.map(function (item) {
                    return item.valor_libro;
                });

                var colors = datosGrafica.map(function () {
                    return getRandomColor();
                });

                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                                label: 'Valor en Libro',
                                data: data,
                                backgroundColor: colors,
                                borderColor: colors,
                                borderWidth: 2,
                                fill: false
                            }]
                    },
                    options: {
                        scales: {
                            x: {
                                display: true,
                                title: {
                                    display: true,
                                    text: 'Fecha'
                                }
                            },
                            y: {
                                display: true,
                                title: {
                                    display: true,
                                    text: 'Valor en Libro'
                                }
                            }
                        }
                    }
                });
            });
        </script>
    </body>
</html>
