package controladores;

import clases.ResumenActivo;
import db.cn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author vladi
 */
@WebServlet(name = "ControladorResumenActivo", urlPatterns = {"/ControladorResumenActivo"})
public class ControladorResumenActivo extends HttpServlet {

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
            out.println("<title>Servlet ControladorResumenActivo</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ControladorResumenActivo at " + request.getContextPath() + "</h1>");
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
        Connection con = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        List<ResumenActivo> listaResumen = new ArrayList<>();

        try {
            con = conexion.getCon();

            // Ejecutar el procedimiento almacenado
            String procedimiento = "{CALL ObtenerResumenActivos()}";
            cs = con.prepareCall(procedimiento);
            rs = cs.executeQuery();

            // Leer los resultados del ResultSet
            while (rs.next()) {
                ResumenActivo resumen = new ResumenActivo();
                resumen.setFamiliaActivos(rs.getString("Familia de Activos"));
                resumen.setCantidadActivos(rs.getObject("Cantidad de Activos") != null ? rs.getInt("Cantidad de Activos") : null);
                resumen.setTotalDinero(rs.getDouble("Total en Dinero"));
                listaResumen.add(resumen);
            }

            // Pasar los resultados a la JSP
            request.setAttribute("resumenActivos", listaResumen);

            // Redirigir a la JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Vistas/ResumenActivo.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al obtener el resumen de activos.");
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
