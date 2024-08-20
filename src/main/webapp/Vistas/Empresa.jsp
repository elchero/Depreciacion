<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Información de la Empresa</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .card {
                background-color: #ffffff;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border-radius: 12px;
                padding: 25px;
            }
            .modal-content {
                border-radius: 12px;
            }
            .card-title {
                font-size: 1.75rem;
                color: #343a40;
                font-weight: bold;
                margin-bottom: 1.5rem;
            }
            .card-text {
                font-size: 1rem;
                color: #6c757d;
                margin-bottom: 0.75rem;
            }
            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
            }
            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
            }
            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
            }
            .btn-success:hover {
                background-color: #218838;
                border-color: #1e7e34;
            }

        </style>
    </head>
    <body>
        <jsp:include page="/nav/navbar.jsp"></jsp:include>
            <div class="container mt-5">
                <h1 class="mb-4 text-center">Información de la Empresa</h1>
                <div class="card mx-auto" style="max-width: 800px;">
                    <div class="card-body">
                        <h2 class="card-title text-center"><c:out value="${empresa.nombre_empresa}"/></h2>
                    <hr>
                    <p class="card-text"><strong>Dirección:</strong> <c:out value="${empresa.direccion}"/></p>
                    <p class="card-text"><strong>Teléfono:</strong> <c:out value="${empresa.telefono}"/></p>
                    <p class="card-text"><strong>Email:</strong> <c:out value="${empresa.email}"/></p>
                    <hr>
                    <p class="card-text"><strong>Misión:</strong></p>
                    <p class="card-text"><c:out value="${empresa.mision}"/></p>
                    <p class="card-text"><strong>Visión:</strong></p>
                    <p class="card-text"><c:out value="${empresa.vision}"/></p>
                    <p class="card-text"><strong>Descripción:</strong></p>
                    <p class="card-text"><c:out value="${empresa.descripcion}"/></p>
                    <br>
                    <div class="text-center">                 
                        <img src="<c:out value="${empresa.logo}"/>" alt="Logo Empresa" class="img-fluid mb-4" style="max-width: 200px;">
                    </div>
                    <div class="text-center">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalActualizar">
                            Actualizar Información
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal para actualizar la información -->
        <div class="modal fade" id="modalActualizar" tabindex="-1" aria-labelledby="modalActualizarLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalActualizarLabel">Actualizar Información de la Empresa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="ControladorEmpresa" method="post">
                            <input type="hidden" name="idempresa" value="${empresa.idempresa}">
                            <div class="mb-3">
                                <label for="nombre_empresa" class="form-label">Nombre de la Empresa</label>
                                <input type="text" class="form-control" id="nombre_empresa" name="nombre_empresa" value="${empresa.nombre_empresa}" required>
                            </div>
                            <div class="mb-3">
                                <label for="direccion" class="form-label">Dirección</label>
                                <input type="text" class="form-control" id="direccion" name="direccion" value="${empresa.direccion}" required>
                            </div>
                            <div class="mb-3">
                                <label for="telefono" class="form-label">Teléfono</label>
                                <input type="text" class="form-control" id="telefono" name="telefono" value="${empresa.telefono}" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${empresa.email}" required>
                            </div>
                            <div class="mb-3">
                                <label for="logo" class="form-label">Logo URL</label>
                                <input type="text" class="form-control" id="logo" name="logo" value="${empresa.logo}" required>
                            </div>
                            <div class="mb-3">
                                <label for="mision" class="form-label">Misión</label>
                                <textarea class="form-control" id="mision" name="mision" rows="3" required>${empresa.mision}</textarea>
                            </div>
                            <div class="mb-3">
                                <label for="vision" class="form-label">Visión</label>
                                <textarea class="form-control" id="vision" name="vision" rows="3" required>${empresa.vision}</textarea>
                            </div>
                            <div class="mb-3">
                                <label for="descripcion" class="form-label">Descripción</label>
                                <textarea class="form-control" id="descripcion" name="descripcion" rows="3" required>${empresa.descripcion}</textarea>
                            </div>
                            <div class="text-center">
                                <button type="submit" class="btn btn-success">Guardar Cambios</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>                          
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
