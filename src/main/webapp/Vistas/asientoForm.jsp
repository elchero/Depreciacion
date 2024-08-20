<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Registro de Asientos Contables</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                font-family: Arial, sans-serif;

                color: #333;
                background-color: #f9f9f9;
            }
            h1 {
                color: #4CAF50;
                border-bottom: 2px solid #4CAF50;
                padding-bottom: 10px;
            }
            form {
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #4CAF50;
                color: #fff;
            }
            tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            .subtotal-row {
                background-color: #e8f5e9;
                font-weight: bold;
            }
            .total-table td {
                border: none;
                padding: 10px;
                font-weight: bold;
            }
            .total-table {
                margin-top: 20px;
            }
            .no-print {
                display: inline-block;
                padding: 10px 20px;
                font-size: 16px;
                cursor: pointer;
                border-radius: 4px;
                margin-right: 10px;
            }
            .no-print.agregar-asiento {
                background-color: #4CAF50;
                color: #fff;
                border: none;
            }
            .no-print.agregar-fila {
                background-color: #2196F3;
                color: #fff;
                border: none;
            }
            .no-print.nuevo-registro {
                background-color: #FF9800;
                color: #fff;
                border: none;
            }
            .no-print.imprimir {
                background-color: #F44336;
                color: #fff;
                border: none;
            }
            .no-print:hover {
                opacity: 0.9;
            }
            @media print {
                .no-print {
                    display: none;
                }
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            input[type="date"],
            input[type="text"],
            input[type="number"],
            select {
                width: 100%;
                padding: 8px;
                border-radius: 4px;
                border: 1px solid #ddd;
            }
            input[type="number"] {
                text-align: right;
            }
            .footer {
                margin-top: 20px;
            }
        </style>
        <script>
            let contadorAsientos = 2;

            function agregarSeparadorAsiento() {
                const table = document.getElementById('detalleAsientoTable');
                const tbody = document.getElementById('tableBody');
                const rowCount = tbody.rows.length;

                // Agregar fila de subtotal para el asiento anterior
                if (rowCount > 1 && tbody.rows[rowCount - 1].classList.contains('subtotal-row') === false) {
                    const subtotalRow = tbody.insertRow(rowCount - 1);
                    subtotalRow.classList.add('subtotal-row');
                    subtotalRow.innerHTML = `
                        <td colspan="5"><strong>Subtotal Asiento</strong></td>
                        <td><strong class="subtotalDebe">0.00</strong></td>
                        <td><strong class="subtotalHaber">0.00</strong></td>
                    `;
                }

                // Agregar separador del nuevo asiento
                const row = tbody.insertRow(rowCount);
                const cell = row.insertCell(0);
                cell.colSpan = 7;
                cell.innerHTML = "<strong>Asiento #" + contadorAsientos + "</strong>";

                contadorAsientos++;

                // Agregar fila de subtotal para el nuevo asiento
                const subtotalRow = tbody.insertRow(rowCount + 1);
                subtotalRow.classList.add('subtotal-row');
                subtotalRow.innerHTML = `
                    <td colspan="5"><strong>Subtotal Asiento</strong></td>
                    <td><strong class="subtotalDebe">0.00</strong></td>
                    <td><strong class="subtotalHaber">0.00</strong></td>
                `;
                calcularTotal();
            }

            function agregarFila() {
                const tbody = document.getElementById('tableBody');
                const rowCount = tbody.rows.length;

                const row = tbody.insertRow(rowCount - 1); // Inserta antes de la última fila (subtotal o total general)

                row.innerHTML = `
                    <td><input type="date" name="fecha"></td>
                    <td><input type="text" name="codigoCuenta"></td>
                    <td><input type="text" name="nombreCuenta"></td>
                    <td><input type="text" name="descripcionCuenta"></td>
                    <td><select name="tipoIva" onchange="calcularTotal()">
                        <option value="ninguno">Ninguno</option>
                        <option value="debitoFiscal">Débito Fiscal</option>
                        <option value="creditoFiscal">Crédito Fiscal</option>
                        <option value="ivaIncluido">IVA Incluido</option>
                    </select></td>
                    <td><input type="number" name="debe" step="0.01" oninput="calcularTotal()"></td>
                    <td><input type="number" name="haber" step="0.01" oninput="calcularTotal()"></td>
                `;
            }

            function calcularTotal() {
                let totalDebe = 0;
                let totalHaber = 0;

                const tbody = document.getElementById('tableBody');
                let currentAsientoTotalDebe = 0;
                let currentAsientoTotalHaber = 0;

                for (let i = 0, row; row = tbody.rows[i]; i++) {
                    if (row.classList.contains('subtotal-row')) {
                        // Actualizar subtotal del asiento
                        row.querySelector('.subtotalDebe').textContent = currentAsientoTotalDebe.toFixed(2);
                        row.querySelector('.subtotalHaber').textContent = currentAsientoTotalHaber.toFixed(2);

                        // Reiniciar para el siguiente asiento
                        currentAsientoTotalDebe = 0;
                        currentAsientoTotalHaber = 0;
                    } else {
                        const tipoIva = row.cells[4]?.querySelector('select')?.value;
                        let debe = parseFloat(row.cells[5]?.querySelector('input')?.value) || 0;
                        let haber = parseFloat(row.cells[6]?.querySelector('input')?.value) || 0;

                        switch (tipoIva) {
                            case "debitoFiscal":
                                debe += debe * 0.13;
                                haber += haber * 0.13;
                                break;
                            case "creditoFiscal":
                                debe += debe * 0.13;
                                haber += haber * 0.13;
                                break;
                            case "ivaIncluido":
                                debe = debe / 1.13;
                                haber = haber / 1.13;
                                break;
                        }

                        currentAsientoTotalDebe += debe;
                        currentAsientoTotalHaber += haber;
                        totalDebe += debe;
                        totalHaber += haber;
                    }
                }

                // Actualizar el total general
                document.getElementById('totalDebe').innerText = totalDebe.toFixed(2);
                document.getElementById('totalHaber').innerText = totalHaber.toFixed(2);
            }

            function imprimirPagina() {
                window.print();
            }

            function nuevoRegistro() {
                if (confirm("Si no has guardado el registro actual, se perderá. ¿Deseas continuar?")) {
                    window.location.reload(); // Recargar la página para simular la creación de un nuevo registro
                }
            }
        </script>
    </head>
    <body>
        <jsp:include page="/nav/navbar.jsp"></jsp:include>
        <h1>Registro de Asientos Contables</h1>
        <form>

            <div id="printSection">
                <div class="table-responsive">
                    <table id="detalleAsientoTable">
                        <thead>
                            <tr>
                                <th>Fecha</th>
                                <th>Código</th>
                                <th>Nombre de la Cuenta</th>
                                <th>Concepto</th>
                                <th>Tipo IVA</th>
                                <th>Debe</th>
                                <th>Haber</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr>
                                <td colspan="7"><strong>Asiento #1</strong></td>
                            </tr>
                            <tr>
                                <td><input type="date" name="fecha"></td>
                                <td><input type="text" name="codigoCuenta"></td>
                                <td><input type="text" name="nombreCuenta"></td>
                                <td><input type="text" name="descripcionCuenta"></td>
                                <td><select name="tipoIva" onchange="calcularTotal()">
                                        <option value="ninguno">Ninguno</option>
                                        <option value="debitoFiscal">Débito Fiscal</option>
                                        <option value="creditoFiscal">Crédito Fiscal</option>
                                        <option value="ivaIncluido">IVA Incluido</option>
                                    </select></td>
                                <td><input type="number" name="debe" step="0.01" oninput="calcularTotal()"></td>
                                <td><input type="number" name="haber" step="0.01" oninput="calcularTotal()"></td>
                            </tr>
                            <tr class="subtotal-row">
                                <td colspan="5"><strong>Total Asiento:</strong></td>
                                <td><strong class="subtotalDebe">0.00</strong></td>
                                <td><strong class="subtotalHaber">0.00</strong></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <br>
                <div class="table-responsive">
                    <table class="total-table">
                        <tr>
                            <td>Total Debe:</td>
                            <td id="totalDebe">0.00</td>
                        </tr>
                        <tr>
                            <td>Total Haber:</td>
                            <td id="totalHaber">0.00</td>
                        </tr>
                    </table>
                </div>
            </div>
            <br>
            <button type="button" class="no-print agregar-asiento" onclick="agregarSeparadorAsiento()">Agregar Asiento</button>
            <button type="button" class="no-print agregar-fila" onclick="agregarFila()">Agregar Fila</button>
            <button type="button" class="no-print nuevo-registro" onclick="nuevoRegistro()">Nuevo Registro</button>
            <br><br>
            <button type="button" class="no-print imprimir" onclick="imprimirPagina()">Imprimir</button>
        </form>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
