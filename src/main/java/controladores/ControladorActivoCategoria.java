package controladores;

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
import modelosDAO.ActivocategoriaDAO;

/**
 *
 * @author vladi
 */
@WebServlet(name = "ControladorActivoCategoria", urlPatterns = {"/ControladorActivoCategoria"})
public class ControladorActivoCategoria extends HttpServlet {

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
            out.println("<title>Servlet ControladorActivoCategoria</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ControladorActivoCategoria at " + request.getContextPath() + "</h1>");
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
            ActivocategoriaDAO dao = new ActivocategoriaDAO();
            // Redirigir a la lista actualizada después de cualquier acción
            List<Activocategoria> listaCategorias = dao.listar();
            request.setAttribute("listaCategorias", listaCategorias);
            request.getRequestDispatcher("/Vistas/ActivosCategoria.jsp").forward(request, response);

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ControladorActivoCategoria.class.getName()).log(Level.SEVERE, null, ex);
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
            //processRequest(request, response);
            String action = request.getParameter("action");
            ActivocategoriaDAO dao = new ActivocategoriaDAO();
            if ("delete".equals(action)) {
                String idStr = request.getParameter("idactivocategoria");
                if (idStr != null) {
                    try {
                        int id = Integer.parseInt(idStr);
                        boolean eliminado = dao.eliminar(id);

                        if (eliminado) {
                            response.sendRedirect("ControladorActivoCategoria");
                            return;  // Asegúrate de retornar aquí para evitar que se haga el forward después
                        } else {
                            request.setAttribute("mensajeError", "No se pudo eliminar el registro.");
                        }
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                        request.setAttribute("mensajeError", "Hubo un error al procesar la eliminación.");
                    }
                }
            }
            else if ("add".equals(action)) {
                String codigo = request.getParameter("codigo");
                String nombre = request.getParameter("nombre");
                double tasa = Double.parseDouble(request.getParameter("tasa"));
                int vida = Integer.parseInt(request.getParameter("vida"));

                Activocategoria categoria = new Activocategoria(codigo, nombre, tasa, vida);
                dao.agregar(categoria);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String codigo = request.getParameter("codigo");
                String nombre = request.getParameter("nombre");
                double tasa = Double.parseDouble(request.getParameter("tasa"));
                int vida = Integer.parseInt(request.getParameter("vida"));

                Activocategoria categoria = new Activocategoria(id, codigo, nombre, tasa, vida);
                dao.actualizar(categoria);
            }
            // Después de cualquier acción, redirigir al listado
            List<Activocategoria> listaCategorias = dao.listar();
            request.setAttribute("listaCategorias", listaCategorias);
            request.getRequestDispatcher("/Vistas/ActivosCategoria.jsp").forward(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ControladorActivoCategoria.class.getName()).log(Level.SEVERE, null, ex);
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
