package controladores;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelos.Asiento;
import modelos.DetalleAsiento;
import modelosDAO.AsientoDAO;
import modelosDAO.DetalleAsientoDAO;

/**
 *
 * @author vladi
 */
@WebServlet(name = "DetalleAsientoServlet", urlPatterns = {"/DetalleAsientoServlet"})
public class DetalleAsientoServlet extends HttpServlet {

    private DetalleAsientoDAO detalleAsientoDAO = new DetalleAsientoDAO();
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
            out.println("<title>Servlet DetalleAsientoServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DetalleAsientoServlet at " + request.getContextPath() + "</h1>");
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
        int asientoId = Integer.parseInt(request.getParameter("asientoId"));
        List<DetalleAsiento> detalles = detalleAsientoDAO.obtenerPorAsientoId(asientoId);
        request.setAttribute("asientoId", asientoId);
        request.setAttribute("detalles", detalles);
        request.getRequestDispatcher("/asientoForm.jsp").forward(request, response);
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
        int asientoId = Integer.parseInt(request.getParameter("asientoId"));
        String[] codigosCuenta = request.getParameterValues("codigoCuenta");
        String[] nombresCuenta = request.getParameterValues("nombreCuenta");
        String[] descripcionesCuenta = request.getParameterValues("descripcionCuenta");
        String[] debes = request.getParameterValues("debe");
        String[] haberes = request.getParameterValues("haber");

        double totalDebe = 0;
        double totalHaber = 0;

        for (int i = 0; i < codigosCuenta.length; i++) {
            double debe = Double.parseDouble(debes[i]);
            double haber = Double.parseDouble(haberes[i]);

            totalDebe += debe;
            totalHaber += haber;

            DetalleAsiento detalleAsiento = new DetalleAsiento();
            detalleAsiento.setAsiento(asientoDAO.obtenerPorId(asientoId));
            detalleAsiento.setCodigoCuenta(codigosCuenta[i]);
            detalleAsiento.setNombreCuenta(nombresCuenta[i]);
            detalleAsiento.setDescripcionCuenta(descripcionesCuenta[i]);
            detalleAsiento.setDebe(debe);
            detalleAsiento.setHaber(haber);
            detalleAsiento.setIvaDebitoFiscal(debe * 0.13);
            detalleAsiento.setIvaCreditoFiscal(haber * 0.13);

            detalleAsientoDAO.crear(detalleAsiento);
        }

        Asiento asiento = asientoDAO.obtenerPorId(asientoId);
        asiento.setTotalDebe(totalDebe);
        asiento.setTotalHaber(totalHaber);

        asientoDAO.actualizar(asiento);

        if (asiento.getTotalDebe() != asiento.getTotalHaber()) {
            request.setAttribute("error", "Los totales de Debe y Haber no coinciden.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("detalles", detalleAsientoDAO.obtenerPorAsientoId(asientoId));
        request.setAttribute("totalDebe", totalDebe);
        request.setAttribute("totalHaber", totalHaber);
        request.setAttribute("asientoId", asientoId);

        request.getRequestDispatcher("/ImprimirAsientos.jsp").forward(request, response);
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
