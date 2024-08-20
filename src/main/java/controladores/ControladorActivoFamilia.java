package controladores;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelos.Activocategoria;
import modelos.Activofamilia;
import modelosDAO.ActivocategoriaDAO;
import modelosDAO.ActivofamiliaDAO;

/**
 *
 * @author vladi
 */
@WebServlet(name = "ControladorActivoFamilia", urlPatterns = {"/ControladorActivoFamilia"})
public class ControladorActivoFamilia extends HttpServlet {

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
            out.println("<title>Servlet ControladorActivoFamilia</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ControladorActivoFamilia at " + request.getContextPath() + "</h1>");
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
        try {
            ActivofamiliaDAO familiaDAO = new ActivofamiliaDAO();
            ActivocategoriaDAO categoriaDAO = new ActivocategoriaDAO();

            List<Activofamilia> listaFamilias = familiaDAO.listar();
            List<Activocategoria> listaCategorias = categoriaDAO.listar();

            request.setAttribute("listaFamilias", listaFamilias);
            request.setAttribute("listaCategorias", listaCategorias);

            request.getRequestDispatcher("/Vistas/ActivosFamilia.jsp").forward(request, response);

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ControladorActivoFamilia.class.getName()).log(Level.SEVERE, null, ex);
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
        try {
            String action = request.getParameter("action");
            ActivofamiliaDAO familiaDAO = new ActivofamiliaDAO();

            if ("delete".equals(action)) {
                String idStr = request.getParameter("idactivofamilia");
                if (idStr != null) {
                    try {
                        int id = Integer.parseInt(idStr);
                        boolean eliminado = familiaDAO.eliminar(id);

                        if (eliminado) {
                            response.sendRedirect("ControladorActivoFamilia");
                            return;
                        } else {
                            request.setAttribute("mensajeError", "No se pudo eliminar el registro.");
                        }
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                        request.setAttribute("mensajeError", "Hubo un error al procesar la eliminación.");
                    }
                }
            } else if ("add".equals(action)) {
                String codigo = request.getParameter("codigo");
                String nombre = request.getParameter("nombreactivofami");
                int idCategoria = Integer.parseInt(request.getParameter("idactivocategoria"));

                Activofamilia familia = new Activofamilia(codigo, nombre, idCategoria);
                familiaDAO.agregar(familia);

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String codigo = request.getParameter("codigo");
                String nombre = request.getParameter("nombreactivofami");
                // int idactivocategoria = Integer.parseInt(request.getParameter("idactivocategoria"));

                Activofamilia familia = new Activofamilia(id, codigo, nombre);
                familiaDAO.actualizar(familia);
            }

            List<Activofamilia> listaFamilias = familiaDAO.listar();
            request.setAttribute("listaFamilias", listaFamilias);
            request.getRequestDispatcher("/Vistas/ActivosFamilia.jsp").forward(request, response);

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ControladorActivoFamilia.class.getName()).log(Level.SEVERE, null, ex);
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
