package modelosDAO;

import db.cn;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Activo;
import modelos.Activocategoria;

/**
 *
 * @author vladi
 */
public class ActivoDAO {

    private cn CN;
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    public ActivoDAO() throws ClassNotFoundException {
        CN = new cn();
    }

    public List<Activo> listarActivos() {
        ArrayList<Activo> lista = new ArrayList<>();
        String sql = "SELECT a.idactivo, e.nombre_empresa, af.nombreactivofami, a.descripcion, "
                + "a.marca, a.modelo, a.serie, a.costo, a.fecha_adquisicion, a.valor_residual "
                + "FROM activo a "
                + "JOIN empresa e ON a.idempresa = e.idempresa "
                + "JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia;";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Activo activos = new Activo();
                activos.setIdactivo(rs.getInt("idactivo"));
                activos.setNombre_empresa(rs.getString("nombre_empresa"));
                activos.setNombreactivofami(rs.getString("nombreactivofami"));
                activos.setDescripcion(rs.getString("descripcion"));
                activos.setMarca(rs.getString("marca"));
                activos.setModelo(rs.getString("modelo"));
                activos.setSerie(rs.getString("serie"));
                activos.setCosto(rs.getDouble("costo"));
                activos.setFecha_adquisicion(rs.getDate("fecha_adquisicion"));
                activos.setValor_residual(rs.getDouble("valor_residual"));

                lista.add(activos);
            }

        } catch (Exception e) {
            e.printStackTrace();

        }
        return lista;
    }

    public Activo obtenerActivoPorId(int idactivo) {
        Activo activo = null;
        String sql = "SELECT a.idactivo, e.nombre_empresa, af.nombreactivofami, a.descripcion, "
                + "a.marca, a.modelo, a.serie, a.costo, a.fecha_adquisicion, a.valor_residual "
                + "FROM activo a "
                + "JOIN empresa e ON a.idempresa = e.idempresa "
                + "JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia "
                + "WHERE a.idactivo = ?";

        Connection con = null;
        try {
            cn connectionManager = new cn(); // Crear instancia de cn
            con = connectionManager.getCon(); // Obtener conexión
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, idactivo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        activo = new Activo();
                        activo.setIdactivo(rs.getInt("idactivo"));
                        activo.setNombre_empresa(rs.getString("nombre_empresa"));
                        activo.setNombreactivofami(rs.getString("nombreactivofami"));
                        activo.setDescripcion(rs.getString("descripcion"));
                        activo.setMarca(rs.getString("marca"));
                        activo.setModelo(rs.getString("modelo"));
                        activo.setSerie(rs.getString("serie"));
                        activo.setCosto(rs.getDouble("costo"));
                        activo.setFecha_adquisicion(rs.getDate("fecha_adquisicion"));
                        activo.setValor_residual(rs.getDouble("valor_residual"));
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("Driver no encontrado: " + e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error en la consulta de activo: " + e.getMessage());
        }

        return activo;
    }

    public boolean agregarActivo(Activo activos) {
        String sql = "INSERT INTO activo (idempresa, idactivofamilia, descripcion, marca, modelo, "
                + "serie, costo, fecha_adquisicion, valor_residual) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setInt(1, activos.getIdempresa());
            ps.setInt(2, activos.getIdactivofamilia());
            ps.setString(3, activos.getDescripcion());
            ps.setString(4, activos.getMarca());
            ps.setString(5, activos.getModelo());
            ps.setString(6, activos.getSerie());
            ps.setDouble(7, activos.getCosto());
            ps.setDate(8, activos.getFecha_adquisicion());
            ps.setDouble(9, activos.getValor_residual());

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;

        }
    }

    public boolean actualizarActivo(Activo activos) {
        String sql = "UPDATE activo SET descripcion = ?, "
                + "marca = ?, modelo = ?, serie = ?, costo = ?, "
                + "fecha_adquisicion = ?, valor_residual = ? WHERE idactivo = ?";

        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setString(1, activos.getDescripcion());
            ps.setString(2, activos.getMarca());
            ps.setString(3, activos.getModelo());
            ps.setString(4, activos.getSerie());
            ps.setDouble(5, activos.getCosto());
            ps.setDate(6, activos.getFecha_adquisicion());
            ps.setDouble(7, activos.getValor_residual());
            ps.setInt(8, activos.getIdactivo());

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarActivos(int idactivo) {
        String sql = "DELETE FROM activo WHERE idactivo=?";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idactivo);

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
