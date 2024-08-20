package controladores;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelos.Empresa;
import modelosDAO.EmpresaDAO;

/**
 *
 * @author vladi
 */
@WebServlet(name = "ControladorEmpresa", urlPatterns = {"/ControladorEmpresa"})
public class ControladorEmpresa extends HttpServlet {

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
            out.println("<title>Servlet ControladorEmpresa</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ControladorEmpresa at " + request.getContextPath() + "</h1>");
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
        try {
            EmpresaDAO dao = new EmpresaDAO();
            Empresa empresa = dao.Listar(1); // Usar idempresa fijo
            request.setAttribute("empresa", empresa);
            request.getRequestDispatcher("/Vistas/Empresa.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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
        //processRequest(request, response);
        try {
            Empresa empresa = new Empresa();
            empresa.setIdempresa(1); // Usar idempresa fijo
            empresa.setNombre_empresa(request.getParameter("nombre_empresa"));
            empresa.setDireccion(request.getParameter("direccion"));
            empresa.setTelefono(request.getParameter("telefono"));
            empresa.setEmail(request.getParameter("email"));
            empresa.setLogo(request.getParameter("logo"));
            empresa.setMision(request.getParameter("mision"));
            empresa.setVision(request.getParameter("vision"));
            empresa.setDescripcion(request.getParameter("descripcion"));

            EmpresaDAO dao = new EmpresaDAO();
            if (dao.actualizar(empresa)) {
                response.sendRedirect("ControladorEmpresa"); // Redirigir a la misma página
            } else {
                // Manejar error si es necesario
            }
        } catch (Exception e) {
            e.printStackTrace();
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
