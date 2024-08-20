<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Familias de Activos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            h2 {
                font-size: 2rem;
                font-weight: bold;
                color: #343a40;
                margin-bottom: 1.5rem;
                text-align: center;
            }
            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
                margin-bottom: 1rem;
            }
            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
            }
            .btn-warning {
                background-color: #ffc107;
                border-color: #ffc107;
            }
            .btn-danger {
                background-color: #dc3545;
                border-color: #dc3545;
            }
            .modal-header {
                background-color: #007bff;
                color: white;
            }
            .modal-title {
                font-size: 1.25rem;
                font-weight: bold;
            }
            .modal-footer .btn-primary {
                background-color: #28a745;
                border-color: #28a745;
            }
            .table {
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            th, td {
                text-align: center;
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/nav/navbar.jsp"></jsp:include>
            <div class="container mt-5">
                <h2>Listado de Familias de Activos</h2>

                <div class="d-flex justify-content-end">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAgregarFamilia">
                        Agregar Familia
                    </button>
                </div>

                <div class="table-responsive">
                    <table id="tablaFamilias" class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Código</th>
                                <th>Nombre</th>
                                <th>Categoría</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="familia" items="${listaFamilias}">
                            <tr>
                                <td>${familia.idactivofamilia}</td>
                                <td>${familia.codigo}</td>
                                <td>${familia.nombreactivofami}</td>
                                <td>${familia.nombreactivocat}</td>
                                <td>
                                    <div class="btn-group" role="group" aria-label="Acciones">
                                        <button type="button" class="btn btn-warning btn-sm"
                                                data-bs-toggle="modal" data-bs-target="#modalEditarFamilia" 
                                                data-id="${familia.idactivofamilia}"
                                                data-codigo="${familia.codigo}"
                                                data-nombre="${familia.nombreactivofami}">
                                            Editar
                                        </button>
                                        <form method="post" action="ControladorActivoFamilia" onsubmit="return confirm('¿Estás seguro de que deseas eliminar esta familia?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="idactivofamilia" value="${familia.idactivofamilia}">
                                            <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal para agregar familia -->
        <div class="modal fade" id="modalAgregarFamilia" tabindex="-1" aria-labelledby="modalAgregarFamiliaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="ControladorActivoFamilia?action=add" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalAgregarFamiliaLabel">Agregar Familia</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="codigo" class="form-label">Código</label>
                                <input type="text" class="form-control" id="codigo" name="codigo" required>
                            </div>
                            <div class="mb-3">
                                <label for="nombreactivofami" class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="nombreactivofami" name="nombreactivofami" required>
                            </div>
                            <div class="mb-3">
                                <label for="idactivocategoria" class="form-label">Categoría</label>
                                <select class="form-control" id="idactivocategoria" name="idactivocategoria" required>
                                    <c:forEach var="categoria" items="${listaCategorias}">
                                        <option value="${categoria.idactivocategoria}">${categoria.nombreactivocat}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="submit" class="btn btn-primary">Agregar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal para editar familia -->
        <div class="modal fade" id="modalEditarFamilia" tabindex="-1" aria-labelledby="modalEditarFamiliaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="ControladorActivoFamilia?action=update" method="post">
                        <input type="hidden" id="editId" name="id">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalEditarFamiliaLabel">Editar Familia</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="editCodigo" class="form-label">Código</label>
                                <input type="text" class="form-control" id="editCodigo" name="codigo" required>
                            </div>
                            <div class="mb-3">
                                <label for="editNombre" class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="editNombre" name="nombreactivofami" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="submit" class="btn btn-primary">Actualizar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
        <script>
                                        $(document).ready(function () {
                                            $('#tablaFamilias').DataTable();

                                            // Para rellenar el modal de edición
                                            $('#modalEditarFamilia').on('show.bs.modal', function (event) {
                                                var button = $(event.relatedTarget);
                                                var id = button.data('id');
                                                var codigo = button.data('codigo');
                                                var nombre = button.data('nombre');

                                                var modal = $(this);
                                                modal.find('#editId').val(id);
                                                modal.find('#editCodigo').val(codigo);
                                                modal.find('#editNombre').val(nombre);
                                            });
                                        });
        </script>

    </body>
</html>
