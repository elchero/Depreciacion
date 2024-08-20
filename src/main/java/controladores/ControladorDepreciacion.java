package controladores;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import clases.Depreciacion;
import com.google.gson.Gson;
import db.cn;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author vladi
 */
@WebServlet(name = "ControladorDepreciacion", urlPatterns = {"/ControladorDepreciacion"})
public class ControladorDepreciacion extends HttpServlet {

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
            out.println("<title>Servlet ControladorDepreciacion</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ControladorDepreciacion at " + request.getContextPath() + "</h1>");
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
        List<Depreciacion> listaDepreciacion = new ArrayList<>();
        List<Depreciacion> listaDepreciacionMensual = new ArrayList<>();
        List<Depreciacion> listaDepreciacionDiaria = new ArrayList<>();
        List<Map<String, Object>> datosGrafica = new ArrayList<>();

        try {
            con = conexion.getCon();

            // Primer procedimiento: calcular_depreciacion_anual
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
                listaDepreciacion.add(depreciacion);
            }

            // Segundo procedimiento: calcular_depreciacion_mensual
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

            // Tercer procedimiento: calcular_depreciacion_diaria
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

            // Cuarto procedimiento: graficar_depreciacion
            String procedimientoGrafica = "{CALL graficar_depreciacion(?)}";
            cs = con.prepareCall(procedimientoGrafica);
            cs.setInt(1, idActivo);
            rs = cs.executeQuery();

            while (rs.next()) {
                Map<String, Object> dataPoint = new HashMap<>();
                dataPoint.put("fecha", rs.getString("fecha"));
                dataPoint.put("valor_libro", rs.getDouble("valor_libro"));
                datosGrafica.add(dataPoint);
            }

            // Pasar los resultados a la JSP
            request.setAttribute("resultados", listaDepreciacion);
            request.setAttribute("resultadosMensuales", listaDepreciacionMensual);
            request.setAttribute("resultadosDiarios", listaDepreciacionDiaria);
            request.setAttribute("datosGrafica", new Gson().toJson(datosGrafica));

            // Redirigir a la JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Vistas/Depreciacion.jsp");
            dispatcher.forward(request, response);

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

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
