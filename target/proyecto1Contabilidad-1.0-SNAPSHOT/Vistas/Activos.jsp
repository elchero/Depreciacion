<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Activos</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                background-color: #f8f9fa;
                font-family: Arial, sans-serif;
            }
            .container {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            }
            h2 {
                font-size: 1.75rem;
                color: #007bff;
            }
            .form-label {
                font-weight: 600;
            }
            .form-control, .form-select {
                border-radius: 0.25rem;
            }
            .btn {
                font-weight: 600;
                transition: background-color 0.2s;
            }
            .btn-primary {
                background-color: #007bff;
                border: none;
            }
            .btn-outline-primary {
                color: #007bff;
                border-color: #007bff;
            }
            .btn-outline-primary:hover {
                background-color: #007bff;
                color: #ffffff;
            }
            .table-responsive {
                margin-top: 20px;
            }
            .table thead th {
                background-color: #007bff;
                color: #ffffff;
                font-size: 14px;
            }
            .dropdown-menu a {
                font-size: 14px;
            }
            .modal-content {
                border-radius: 0.75rem;
            }
            .modal-header {
                border-bottom: none;
            }
            .modal-title {
                font-size: 1.5rem;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/nav/navbar.jsp"></jsp:include>
            <div class="container mt-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Gestión de Activos</h2>
                    <a href="${pageContext.request.contextPath}/ControladorResumenActivo" class="btn btn-outline-primary">
                    <i class="bi bi-bar-chart-fill"></i> Ver Resumen de Activos
                </a>
            </div>
            <form id="formActivo">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="activocategoria" class="form-label">Categoría:</label>
                        <select id="activocategoria" class="form-select js-example-basic-single" style="width: 100%;">
                            <option value="">Seleccionar Categoría</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="activofamilia" class="form-label">Familia:</label>
                        <select id="activofamilia" class="form-select js-example-basic-single" style="width: 100%;">
                            <option value="">Seleccionar Familia</option>
                        </select>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="descripcion" class="form-label">Descripción:</label>
                        <input type="text" class="form-control" id="descripcion">
                    </div>
                    <div class="col-md-6">
                        <label for="marca" class="form-label">Marca:</label>
                        <input type="text" class="form-control" id="marca">
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="modelo" class="form-label">Modelo:</label>
                        <input type="text" class="form-control" id="modelo">
                    </div>
                    <div class="col-md-6">
                        <label for="serie" class="form-label">Serie:</label>
                        <input type="text" class="form-control" id="serie">
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="costo" class="form-label">Costo:</label>
                        <input type="number" class="form-control" id="costo" min="0">
                    </div>
                    <div class="col-md-6">
                        <label for="fecha_adquisicion" class="form-label">Fecha de Adquisición:</label>
                        <input type="date" class="form-control" id="fecha_adquisicion">
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="valor_residual" class="form-label">Valor Residual:</label>
                        <input type="number" min="0" class="form-control" id="valor_residual" value="0">
                    </div>
                    <div class="col-md-6 d-none">
                        <label for="idempresa" class="form-label">Empresa:</label>
                        <input type="number" class="form-control" id="idempresa" value="1">
                    </div>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                    <button type="button" id="btnGuardar" class="btn btn-primary">Guardar</button>
                    <a href="https://firebasestorage.googleapis.com/v0/b/easyshop-8363a.appspot.com/o/Instructivo%20de%20registro%20y%20control%20de%20bienes%20muebles%20de%20la%20SSF.pdf?alt=media&token=fc042ae2-d6fc-4c31-8196-22fa85a17061"  target="_blank" class="btn btn-link">Material de apoyo</a>
                </div>
            </form>

            <hr>

            <!-- Tabla de Activos -->
            <div class="table-responsive">
                <table id="tablaActivos" class="table table-hover table-bordered table-striped table-sm" style="width: 100%; font-size: 14px;">
                    <thead class="table-dark text-center">
                        <tr>
                            <th>ID</th>
                            <th>Empresa</th>
                            <th>Familia</th>
                            <th>Descripción</th>
                            <th>Marca</th>
                            <th>Modelo</th>
                            <th>Serie</th>
                            <th>Costo</th>
                            <th>Fecha Adquisición</th>
                            <th>Valor Residual</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="activo" items="${activos}">
                            <tr class="text-center">
                                <td>${activo.idactivo}</td>
                                <td>${activo.nombre_empresa}</td>
                                <td>${activo.nombreactivofami}</td>
                                <td>${activo.descripcion}</td>
                                <td>${activo.marca}</td>
                                <td>${activo.modelo}</td>
                                <td>${activo.serie}</td>
                                <td>
                                    <fmt:formatNumber value="${activo.costo}" type="currency" currencySymbol="$"/>
                                </td>
                                <td>
                                    <fmt:formatDate value="${activo.fecha_adquisicion}" pattern="dd-MM-yyyy"/>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${activo.valor_residual}" type="currency" currencySymbol="$"/>
                                </td>                               
                                <td>
                                    <!-- Acciones (actualizar, eliminar) -->
                                    <div class="btn-group" role="group">
                                        <button id="btnGroupDrop1" type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                            Acciones
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="btnGroupDrop1">
                                            <li><a class="dropdown-item text-primary" href="ControladorDepreciacion?idactivo=${activo.idactivo}">Depreciación</a></li>
                                            <li><a class="dropdown-item text-success" href="ControladorExportarExcelDepreciaciones?idactivo=${activo.idactivo}">Exportar Depreciación a Excel</a></li>
                                            <li><a class="dropdown-item text-warning btnEditar" href="#" data-id="${activo.idactivo}">Editar</a></li>
                                            <li><a class="dropdown-item text-danger btnEliminar" href="#" data-id="${activo.idactivo}">Eliminar</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal de Edición -->
        <div class="modal fade" id="modalEditar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Editar Activo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formEditarActivo">
                            <input type="hidden" id="idactivo">
                            <div class="mb-3">
                                <label for="edit-descripcion" class="form-label">Descripción:</label>
                                <input type="text" class="form-control" id="edit-descripcion">
                            </div>
                            <div class="mb-3">
                                <label for="edit-marca" class="form-label">Marca:</label>
                                <input type="text" class="form-control" id="edit-marca">
                            </div>
                            <div class="mb-3">
                                <label for="edit-modelo" class="form-label">Modelo:</label>
                                <input type="text" class="form-control" id="edit-modelo">
                            </div>
                            <div class="mb-3">
                                <label for="edit-serie" class="form-label">Serie:</label>
                                <input type="text" class="form-control" id="edit-serie">
                            </div>
                            <div class="mb-3">
                                <label for="edit-costo" class="form-label">Costo:</label>
                                <input type="number" class="form-control" id="edit-costo">
                            </div>
                            <div class="mb-3">
                                <label for="edit-fecha_adquisicion" class="form-label">Fecha de Adquisición:</label>
                                <input type="date" class="form-control" id="edit-fecha_adquisicion">
                            </div>
                            <div class="mb-3">
                                <label for="edit-valor_residual" class="form-label">Valor Residual:</label>
                                <input type="number" class="form-control" id="edit-valor_residual">
                            </div>
                            <button type="button" id="btnActualizar" class="btn btn-primary">Actualizar</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>


        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>

        <!-- Script JS para el manejo de los datos -->
        <script>
            $(document).ready(function () {
                // Configurar Select2 para Categorías y Familias
                $('#activocategoria').select2({
                    placeholder: 'Seleccionar Categoría',
                    ajax: {
                        url: 'ControladorActivo?action=getCategorias',
                        dataType: 'json',
                        delay: 250,
                        processResults: function (data) {
                            return {
                                results: $.map(data, function (item) {
                                    return {
                                        id: item.id,
                                        text: item.text
                                    };
                                })
                            };
                        }
                    }
                });

                $('#activocategoria').on('change', function () {
                    var categoriaId = $(this).val();
                    $('#activofamilia').val(null).trigger('change');
                    $('#activofamilia').select2({
                        placeholder: 'Seleccionar Familia',
                        ajax: {
                            url: 'ControladorActivo?action=getFamilias&categoriaId=' + categoriaId,
                            dataType: 'json',
                            delay: 250,
                            processResults: function (data) {
                                return {
                                    results: $.map(data, function (item) {
                                        return {
                                            id: item.id,
                                            text: item.text
                                        };
                                    })
                                };
                            }
                        }
                    });
                });

                // Inicializar DataTables
                var table = $('#tablaActivos').DataTable();

                // Validaciones y Manejo botón Guardar
                $('#btnGuardar').click(function () {
                    // Validar campos
                    if ($('#activocategoria').val() === "") {
                        alert("Debe seleccionar una categoría.");
                        $('#activocategoria').focus();
                        return false;
                    }

                    if ($('#activofamilia').val() === "") {
                        alert("Debe seleccionar una familia.");
                        $('#activofamilia').focus();
                        return false;
                    }

                    if ($('#descripcion').val().trim() === "") {
                        alert("Debe agregar una descripción.");
                        $('#descripcion').focus();
                        return false;
                    }

                    let costo = $('#costo').val();
                    if (costo === "" || isNaN(costo) || parseFloat(costo) < 0 || !/^\d+(\.\d{1,2})?$/.test(costo)) {
                        alert("Debe agregar un costo válido (mayor o igual a 0 y con máximo dos decimales).");
                        $('#costo').focus();
                        return false;
                    }

                    if ($('#fecha_adquisicion').val() === "") {
                        alert("Debe agregar una fecha de adquisición.");
                        $('#fecha_adquisicion').focus();
                        return false;
                    }

                    let valor_residual = $('#valor_residual').val();
                    if (valor_residual === "" || isNaN(valor_residual) || parseFloat(valor_residual) < 0 || !/^\d+(\.\d{1,2})?$/.test(valor_residual)) {
                        alert("Debe agregar un valor residual válido (mayor o igual a 0 y con máximo dos decimales).");
                        $('#valor_residual').focus();
                        return false;
                    }

                    // Si todas las validaciones pasan, se procede a enviar los datos
                    var activo = {
                        idempresa: $('#idempresa').val(),
                        idactivofamilia: $('#activofamilia').val(),
                        descripcion: $('#descripcion').val(),
                        marca: $('#marca').val(),
                        modelo: $('#modelo').val(),
                        serie: $('#serie').val(),
                        costo: $('#costo').val(),
                        fecha_adquisicion: $('#fecha_adquisicion').val(),
                        valor_residual: $('#valor_residual').val()
                    };
                    $.ajax({
                        url: 'ControladorActivo',
                        type: 'POST',
                        data: {action: 'add', ...activo},
                        success: function (response) {
                            alert(response);
                            location.reload();
                        },
                        error: function () {
                            alert('Error al agregar activo');
                        }
                    });
                });

                $(document).on('click', '.btnEditar', function () {
                    var idactivo = $(this).data('id');
                    $.ajax({
                        url: 'ControladorActivo',
                        type: 'GET',
                        data: {action: 'getActivo', idactivo: idactivo},
                        success: function (data) {
                            if (data) {
                                // Llenar formulario con datos del activo
                                $('#idactivo').val(data.idactivo);
                                $('#edit-descripcion').val(data.descripcion);
                                $('#edit-marca').val(data.marca);
                                $('#edit-modelo').val(data.modelo);
                                $('#edit-serie').val(data.serie);
                                $('#edit-costo').val(data.costo);
                                $('#edit-fecha_adquisicion').val(data.fecha_adquisicion);
                                $('#edit-valor_residual').val(data.valor_residual);

                                // Mostrar el modal de edición
                                $('#modalEditar').modal('show');
                            } else {
                                alert('No se pudieron cargar los datos del activo.');
                            }
                        },
                        error: function () {
                            alert('Error al obtener datos del activo.');
                        }
                    });
                });

                // Validaciones y Manejo botón Actualizar
                $('#btnActualizar').click(function () {
                    // Validar campos
                    if ($('#edit-descripcion').val().trim() === "") {
                        alert("Debe agregar una descripción.");
                        $('#edit-descripcion').focus();
                        return false;
                    }

                    let costo = $('#edit-costo').val();
                    if (costo === "" || isNaN(costo) || parseFloat(costo) < 0 || !/^\d+(\.\d{1,2})?$/.test(costo)) {
                        alert("Debe agregar un costo válido (mayor o igual a 0 y con máximo dos decimales).");
                        $('#edit-costo').focus();
                        return false;
                    }

                    if ($('#edit-fecha_adquisicion').val() === "") {
                        alert("Debe agregar una fecha de adquisición.");
                        $('#edit-fecha_adquisicion').focus();
                        return false;
                    }

                    let valor_residual = $('#edit-valor_residual').val();
                    if (valor_residual === "" || isNaN(valor_residual) || parseFloat(valor_residual) < 0 || !/^\d+(\.\d{1,2})?$/.test(valor_residual)) {
                        alert("Debe agregar un valor residual válido (mayor o igual a 0 y con máximo dos decimales).");
                        $('#edit-valor_residual').focus();
                        return false;
                    }

                    // Si todas las validaciones pasan, se procede a actualizar los datos
                    var activo = {
                        idactivo: $('#idactivo').val(),
                        descripcion: $('#edit-descripcion').val(),
                        marca: $('#edit-marca').val(),
                        modelo: $('#edit-modelo').val(),
                        serie: $('#edit-serie').val(),
                        costo: $('#edit-costo').val(),
                        fecha_adquisicion: $('#edit-fecha_adquisicion').val(),
                        valor_residual: $('#edit-valor_residual').val()
                    };
                    $.ajax({
                        url: 'ControladorActivo',
                        type: 'POST',
                        data: {action: 'edit', ...activo},
                        success: function (response) {
                            alert(response);
                            location.reload();
                        },
                        error: function () {
                            alert('Error al actualizar activo');
                        }
                    });
                });

                // Manejar botón Eliminar
                $(document).on('click', '.btnEliminar', function () {
                    var idactivo = $(this).data('id');
                    if (confirm('¿Estás seguro de que deseas eliminar este activo?')) {
                        $.ajax({
                            url: 'ControladorActivo',
                            type: 'POST',
                            data: {
                                action: 'delete',
                                idactivo: idactivo
                            },
                            success: function (response) {
                                alert(response);
                                location.reload(); // Recargar la página para reflejar los cambios
                            },
                            error: function (xhr, status, error) {
                                console.error('Error al eliminar el activo:', error);
                            }
                        });
                    }
                });
            });
        </script>
    </body>
</html>
