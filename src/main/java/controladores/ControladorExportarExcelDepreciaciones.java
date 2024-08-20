package controladores;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import clases.Depreciacion;
import db.cn;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author vladi
 */
@WebServlet(name = "ControladorExportarExcelDepreciaciones", urlPatterns = {"/ControladorExportarExcelDepreciaciones"})
public class ControladorExportarExcelDepreciaciones extends HttpServlet {

    private cn conexion;

    @Override
    public void init() throws ServletException {
        try {
            conexion = new cn();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ControladorExportarExcelDepreciaciones</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ControladorExportarExcelDepreciaciones at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        int idActivo = Integer.parseInt(request.getParameter("idactivo"));
        Connection con = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        List<Depreciacion> listaDepreciacionAnual = new ArrayList<>();
        List<Depreciacion> listaDepreciacionMensual = new ArrayList<>();
        List<Depreciacion> listaDepreciacionDiaria = new ArrayList<>();

        try {
            con = conexion.getCon();

            // Procedimiento para Depreciación Anual
            String procedimientoCalculoAnual = "{CALL calcular_depreciacion_anual(?)}";
            cs = con.prepareCall(procedimientoCalculoAnual);
            cs.setInt(1, idActivo);
            rs = cs.executeQuery();

            while (rs.next()) {
                Depreciacion depreciacion = new Depreciacion();
                depreciacion.setAnio(rs.getString("anio"));
                depreciacion.setNombreactivofami(rs.getString("nombreactivofami"));
                depreciacion.setMarca(rs.getString("marca"));
                depreciacion.setDepreciacionAnual(rs.getDouble("depreciacion_anual"));
                depreciacion.setDepreciacionAcumulada(rs.getDouble("depreciacion_acumulada"));
                depreciacion.setValorEnLibro(rs.getDouble("valor_en_libro"));
                listaDepreciacionAnual.add(depreciacion);
            }

            // Procedimiento para Depreciación Mensual
            String procedimientoCalculoMensual = "{CALL calcular_depreciacion_mensual(?)}";
            cs = con.prepareCall(procedimientoCalculoMensual);
            cs.setInt(1, idActivo);
            rs = cs.executeQuery();

            while (rs.next()) {
                Depreciacion depreciacionMensual = new Depreciacion();
                depreciacionMensual.setMes(rs.getString("mes"));
                depreciacionMensual.setNombreactivofami(rs.getString("nombreactivofami"));
                depreciacionMensual.setMarca(rs.getString("marca"));
                depreciacionMensual.setDepreciacionMensual(rs.getDouble("depreciacion_mensual"));
                depreciacionMensual.setDepreciacionAcumulada(rs.getDouble("depreciacion_acumulada"));
                depreciacionMensual.setValorEnLibro(rs.getDouble("valor_en_libro"));
                listaDepreciacionMensual.add(depreciacionMensual);
            }

            // Procedimiento para Depreciación Diaria
            String procedimientoCalculoDiario = "{CALL calcular_depreciacion_diaria(?)}";
            cs = con.prepareCall(procedimientoCalculoDiario);
            cs.setInt(1, idActivo);
            rs = cs.executeQuery();

            while (rs.next()) {
                Depreciacion depreciacionDiaria = new Depreciacion();
                depreciacionDiaria.setDia(rs.getString("dia"));
                depreciacionDiaria.setNombreactivofami(rs.getString("nombreactivofami"));
                depreciacionDiaria.setMarca(rs.getString("marca"));
                depreciacionDiaria.setDepreciacionDiaria(rs.getDouble("depreciacion_diaria"));
                depreciacionDiaria.setDepreciacionAcumulada(rs.getDouble("depreciacion_acumulada"));
                depreciacionDiaria.setValorEnLibro(rs.getDouble("valor_en_libro"));
                listaDepreciacionDiaria.add(depreciacionDiaria);
            }

            // Generar archivo Excel
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment;filename=depreciacion_activo_" + idActivo + ".xlsx");

            Workbook workbook = new XSSFWorkbook();
            crearHojaDepreciacion(workbook, "Depreciación Anual", listaDepreciacionAnual);
            crearHojaDepreciacion(workbook, "Depreciación Mensual", listaDepreciacionMensual);
            crearHojaDepreciacion(workbook, "Depreciación Diaria", listaDepreciacionDiaria);

            // Enviar el archivo al cliente
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            } finally {
                workbook.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al calcular la depreciación.");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void crearHojaDepreciacion(Workbook workbook, String nombreHoja, List<Depreciacion> listaDepreciacion) {
        Sheet sheet = workbook.createSheet(nombreHoja);

        // Crear la fila de encabezado
        Row headerRow = sheet.createRow(0);
        String[] headers;
        if (nombreHoja.equals("Depreciación Anual")) {
            headers = new String[]{"Año", "Nombre Activo", "Marca", "Depreciación Anual", "Depreciación Acumulada", "Valor en Libro"};
        } else if (nombreHoja.equals("Depreciación Mensual")) {
            headers = new String[]{"Mes", "Nombre Activo", "Marca", "Depreciación Mensual", "Depreciación Acumulada", "Valor en Libro"};
        } else {
            headers = new String[]{"Día", "Nombre Activo", "Marca", "Depreciación Diaria", "Depreciación Acumulada", "Valor en Libro"};
        }

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
        }

        // Llenar las filas con datos
        int rowNum = 1;
        for (Depreciacion depreciacion : listaDepreciacion) {
            Row row = sheet.createRow(rowNum++);
            if (nombreHoja.equals("Depreciación Anual")) {
                row.createCell(0).setCellValue(depreciacion.getAnio());
                row.createCell(1).setCellValue(depreciacion.getNombreactivofami());
                row.createCell(2).setCellValue(depreciacion.getMarca());
                row.createCell(3).setCellValue(depreciacion.getDepreciacionAnual());
                row.createCell(4).setCellValue(depreciacion.getDepreciacionAcumulada());
                row.createCell(5).setCellValue(depreciacion.getValorEnLibro());
            } else if (nombreHoja.equals("Depreciación Mensual")) {
                row.createCell(0).setCellValue(depreciacion.getMes());
                row.createCell(1).setCellValue(depreciacion.getNombreactivofami());
                row.createCell(2).setCellValue(depreciacion.getMarca());
                row.createCell(3).setCellValue(depreciacion.getDepreciacionMensual());
                row.createCell(4).setCellValue(depreciacion.getDepreciacionAcumulada());
                row.createCell(5).setCellValue(depreciacion.getValorEnLibro());
            } else {
                row.createCell(0).setCellValue(depreciacion.getDia());
                row.createCell(1).setCellValue(depreciacion.getNombreactivofami());
                row.createCell(2).setCellValue(depreciacion.getMarca());
                row.createCell(3).setCellValue(depreciacion.getDepreciacionDiaria());
                row.createCell(4).setCellValue(depreciacion.getDepreciacionAcumulada());
                row.createCell(5).setCellValue(depreciacion.getValorEnLibro());
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
