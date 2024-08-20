<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Categorías de Activos</title>
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
                <h2>Listado de Categorías de Activos</h2>

                <!-- Botón para abrir el modal de agregar categoría -->
                <div class="d-flex justify-content-end">
                    <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#modalAgregarCategoria">
                        Agregar Categoría
                    </button>
                </div>

                <div class="table-responsive">
                    <table id="tablaCategorias" class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Código</th>
                                <th>Nombre</th>
                                <th>Tasa Depreciación (%)</th>
                                <th>Vida Útil (años)</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="categoria" items="${listaCategorias}">
                            <tr>
                                <td>${categoria.idactivocategoria}</td>
                                <td>${categoria.codigo}</td>
                                <td>${categoria.nombreactivocat}</td>
                                <td>${categoria.tasa_depreciacion}</td>
                                <td>${categoria.vida_util}</td>
                                <td>
                                    <div class="btn-group" role="group" aria-label="Acciones">
                                        <button type="button" class="btn btn-warning btn-sm" 
                                                data-bs-toggle="modal" data-bs-target="#modalEditarCategoria" 
                                                data-id="${categoria.idactivocategoria}"
                                                data-codigo="${categoria.codigo}"
                                                data-nombre="${categoria.nombreactivocat}"
                                                data-tasa="${categoria.tasa_depreciacion}"
                                                data-vida="${categoria.vida_util}">
                                            Editar
                                        </button>
                                        <form method="post" action="ControladorActivoCategoria" onsubmit="return confirm('¿Estás seguro de que deseas eliminar esta categoría?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="idactivocategoria" value="${categoria.idactivocategoria}">
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

        <!-- Modal para agregar categoría -->
        <div class="modal fade" id="modalAgregarCategoria" tabindex="-1" aria-labelledby="modalAgregarCategoriaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="ControladorActivoCategoria?action=add" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalAgregarCategoriaLabel">Agregar Categoría</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="codigo" class="form-label">Código</label>
                                <input type="text" class="form-control" id="codigo" name="codigo" required>
                            </div>
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" required>
                            </div>
                            <div class="mb-3">
                                <label for="tasa" class="form-label">Tasa de Depreciación (%)</label>
                                <input type="number" step="0.01" class="form-control" id="tasa" name="tasa" required>
                            </div>
                            <div class="mb-3">
                                <label for="vida" class="form-label">Vida Útil (años)</label>
                                <input type="number" class="form-control" id="vida" name="vida" required>
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

        <!-- Modal para editar categoría -->
        <div class="modal fade" id="modalEditarCategoria" tabindex="-1" aria-labelledby="modalEditarCategoriaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="ControladorActivoCategoria?action=update" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalEditarCategoriaLabel">Editar Categoría</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="editId" name="id">
                            <div class="mb-3">
                                <label for="editCodigo" class="form-label">Código</label>
                                <input type="text" class="form-control" id="editCodigo" name="codigo" required>
                            </div>
                            <div class="mb-3">
                                <label for="editNombre" class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="editNombre" name="nombre" required>
                            </div>
                            <div class="mb-3">
                                <label for="editTasa" class="form-label">Tasa de Depreciación (%)</label>
                                <input type="number" step="0.01" class="form-control" id="editTasa" name="tasa" required>
                            </div>
                            <div class="mb-3">
                                <label for="editVida" class="form-label">Vida Útil (años)</label>
                                <input type="number" class="form-control" id="editVida" name="vida" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        $(document).ready(function () {
                                            $('#tablaCategorias').DataTable();

                                            $('#modalEditarCategoria').on('show.bs.modal', function (event) {
                                                var button = $(event.relatedTarget); // Botón que activó el modal
                                                var id = button.data('id');
                                                var codigo = button.data('codigo');
                                                var nombre = button.data('nombre');
                                                var tasa = button.data('tasa');
                                                var vida = button.data('vida');

                                                var modal = $(this);
                                                modal.find('#editId').val(id);
                                                modal.find('#editCodigo').val(codigo);
                                                modal.find('#editNombre').val(nombre);
                                                modal.find('#editTasa').val(tasa);
                                                modal.find('#editVida').val(vida);
                                            });
                                        });
        </script>

    </body>
</html>
