package controladores;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelos.Asiento;
import modelosDAO.AsientoDAO;

/**
 *
 * @author vladi
 */
@WebServlet(name = "AsientoServlet", urlPatterns = {"/AsientoServlet"})
public class AsientoServlet extends HttpServlet {

    private AsientoDAO asientoDAO = new AsientoDAO();

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
            out.println("<title>Servlet AsientoServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AsientoServlet at " + request.getContextPath() + "</h1>");
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
        //  processRequest(request, response);
        List<Asiento> asientos = asientoDAO.obtenerTodos();
        request.setAttribute("asientos", asientos);
        request.getRequestDispatcher("/asientos.jsp").forward(request, response);
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
        //processRequest(request, response);
        String titulo = request.getParameter("titulo");
        String fechaString = request.getParameter("fecha");
        String descripcion = request.getParameter("descripcion");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date fecha = null;
        try {
            fecha = sdf.parse(fechaString);
        } catch (ParseException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
            return;
        }

        Asiento asiento = new Asiento();
        asiento.setTitulo(titulo);
        asiento.setFecha(fecha);
        asiento.setDescripcion(descripcion);
        asiento.setTotalDebe(0);
        asiento.setTotalHaber(0);

        asientoDAO.crear(asiento);

        response.sendRedirect("asientoList.jsp");
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
