package controladores;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelos.Activo;
import modelos.Activocategoria;
import modelos.Activofamilia;
import modelosDAO.ActivoDAO;
import modelosDAO.ActivocategoriaDAO;
import modelosDAO.ActivofamiliaDAO;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author vladi
 */
@WebServlet(name = "ControladorActivo", urlPatterns = {"/ControladorActivo"})
public class ControladorActivo extends HttpServlet {

    private ActivoDAO activoDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            activoDAO = new ActivoDAO(); // Inicializar la instancia de ActivoDAO
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ControladorActivo.class.getName()).log(Level.SEVERE, null, ex);
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
            out.println("<title>Servlet ControladorActivo</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ControladorActivo at " + request.getContextPath() + "</h1>");
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

        String action = request.getParameter("action");
        if ("getCategorias".equals(action)) {
            getCategorias(response);
        } else if ("getFamilias".equals(action)) {
            int categoriaId = Integer.parseInt(request.getParameter("categoriaId"));
            getFamilias(response, categoriaId);
        } else if ("getActivo".equals(action)) {
            int idactivo = Integer.parseInt(request.getParameter("idactivo"));
            getActivo(response, idactivo);
        } else {
            listarActivos(request, response);
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
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "add":
                    agregarActivo(request, response);
                    break;
                case "edit":
                    editarActivo(request, response);
                    break;
                case "delete":
                    eliminarActivo(request, response);
                    break;
                default:
                    listarActivos(request, response);
                    break;
            }
        }
        //processRequest(request, response);
    }

    private void getCategorias(HttpServletResponse response) throws IOException {
        try {
            ActivocategoriaDAO dao = new ActivocategoriaDAO();
            List<Activocategoria> categorias = dao.obtenerCategorias();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            JSONArray jsonArray = new JSONArray();
            for (Activocategoria categoria : categorias) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("id", categoria.getIdactivocategoria());
                jsonObject.put("text", categoria.getNombreactivocat());
                jsonArray.put(jsonObject);
            }
            PrintWriter out = response.getWriter();
            out.print(jsonArray.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void getFamilias(HttpServletResponse response, int categoriaId) throws IOException {
        try {
            ActivofamiliaDAO dao = new ActivofamiliaDAO();
            List<Activofamilia> familias = dao.obtenerFamiliasPorCategoria(categoriaId);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            JSONArray jsonArray = new JSONArray();
            for (Activofamilia familia : familias) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("id", familia.getIdactivofamilia());
                jsonObject.put("text", familia.getNombreactivofami());
                jsonArray.put(jsonObject);
            }
            PrintWriter out = response.getWriter();
            out.print(jsonArray.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void agregarActivo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Activo activo = new Activo();
        activo.setIdempresa(Integer.parseInt(request.getParameter("idempresa")));
        activo.setIdactivofamilia(Integer.parseInt(request.getParameter("idactivofamilia")));
        activo.setDescripcion(request.getParameter("descripcion"));
        activo.setMarca(request.getParameter("marca"));
        activo.setModelo(request.getParameter("modelo"));
        activo.setSerie(request.getParameter("serie"));
        activo.setCosto(Double.parseDouble(request.getParameter("costo")));
        activo.setFecha_adquisicion(Date.valueOf(request.getParameter("fecha_adquisicion")));
        activo.setValor_residual(Double.parseDouble(request.getParameter("valor_residual")));

        if (activoDAO.agregarActivo(activo)) {
            response.getWriter().write("Activo agregado exitosamente");
        } else {
            response.getWriter().write("Error al agregar el activo");
        }
    }

    private void editarActivo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Activo activo = new Activo();
        activo.setIdactivo(Integer.parseInt(request.getParameter("idactivo")));
        activo.setDescripcion(request.getParameter("descripcion"));
        activo.setMarca(request.getParameter("marca"));
        activo.setModelo(request.getParameter("modelo"));
        activo.setSerie(request.getParameter("serie"));
        activo.setCosto(Double.parseDouble(request.getParameter("costo")));
        activo.setFecha_adquisicion(Date.valueOf(request.getParameter("fecha_adquisicion")));
        activo.setValor_residual(Double.parseDouble(request.getParameter("valor_residual")));

        if (activoDAO.actualizarActivo(activo)) {
            response.getWriter().write("Activo actualizado exitosamente");
        } else {
            response.getWriter().write("Error al actualizar el activo");
        }
    }

    private void eliminarActivo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idactivo = Integer.parseInt(request.getParameter("idactivo"));

        if (activoDAO.eliminarActivos(idactivo)) {
            response.getWriter().write("Activo eliminado exitosamente");
        } else {
            response.getWriter().write("Error al eliminar el activo");
        }
    }

    private void listarActivos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<Activo> activos = (ArrayList<Activo>) activoDAO.listarActivos();
        request.setAttribute("activos", activos);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/Vistas/Activos.jsp");
        dispatcher.forward(request, response);
    }

    private void getActivo(HttpServletResponse response, int idactivo) throws IOException {
        try {
            Activo activo = activoDAO.obtenerActivoPorId(idactivo);
            JSONObject jsonObject = new JSONObject();
            if (activo != null) {
                jsonObject.put("idactivo", activo.getIdactivo());
                jsonObject.put("descripcion", activo.getDescripcion());
                jsonObject.put("marca", activo.getMarca());
                jsonObject.put("modelo", activo.getModelo());
                jsonObject.put("serie", activo.getSerie());
                jsonObject.put("costo", activo.getCosto());
                jsonObject.put("fecha_adquisicion", activo.getFecha_adquisicion().toString());
                jsonObject.put("valor_residual", activo.getValor_residual());
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(jsonObject.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
