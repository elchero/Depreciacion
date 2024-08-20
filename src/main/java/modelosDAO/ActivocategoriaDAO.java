package modelosDAO;

import db.cn;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Activocategoria;

/**
 *
 * @author vladi
 */
public class ActivocategoriaDAO {

    private cn CN;
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    public ActivocategoriaDAO() throws ClassNotFoundException {
        CN = new cn();
    }

    public List<Activocategoria> listar() {
        List<Activocategoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM activocategoria";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Activocategoria categoria = new Activocategoria();
                categoria.setIdactivocategoria(rs.getInt("idactivocategoria"));
                categoria.setCodigo(rs.getString("codigo"));
                categoria.setNombreactivocat(rs.getString("nombreactivocat"));
                categoria.setTasa_depreciacion(rs.getDouble("tasa_depreciacion"));
                categoria.setVida_util(rs.getInt("vida_util"));
                lista.add(categoria);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    //buscar activocategoria por ID
    public Activocategoria ListarById(int id) {
        Activocategoria categoria = new Activocategoria();
        String sql = "SELECT * FROM activocategoria WHERE idactivocategoria=?";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                categoria.setIdactivocategoria(rs.getInt("idactivocategoria"));
                categoria.setCodigo(rs.getString("codigo"));
                categoria.setNombreactivocat(rs.getString("nombreactivocat"));
                categoria.setTasa_depreciacion(rs.getDouble("tasa_depreciacion"));
                categoria.setVida_util(rs.getInt("vida_util"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return categoria;
    }

    //Agregar una nueva ActivoCategoria
    public boolean agregar(Activocategoria categoria) {
        String sql = "INSERT INTO activocategoria(codigo, nombreactivocat, tasa_depreciacion, vida_util) VALUES(?,?,?,?)";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);

            ps.setString(1, categoria.getCodigo());
            ps.setString(2, categoria.getNombreactivocat());
            ps.setDouble(3, categoria.getTasa_depreciacion());
            ps.setInt(4, categoria.getVida_util());
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            return false;
        }
    }

    //Actualizar la informacion de categoria
    public boolean actualizar(Activocategoria categoria) {
        String sql = "UPDATE activocategoria SET codigo=?, nombreactivocat=?, tasa_depreciacion=?, vida_util=?"
                + " WHERE idactivocategoria=?";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setString(1, categoria.getCodigo());
            ps.setString(2, categoria.getNombreactivocat());
            ps.setDouble(3, categoria.getTasa_depreciacion());
            ps.setInt(4, categoria.getVida_util());
            ps.setInt(5, categoria.getIdactivocategoria());
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            return false;
        }
    }

    //Eliminar la informacion de una activocategoria
    public boolean eliminar(int idactivocategoria) {
        String sql = "DELETE FROM activocategoria WHERE idactivocategoria=?";
        try (Connection con = CN.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idactivocategoria);
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Activocategoria> obtenerCategorias() {
        List<Activocategoria> categorias = new ArrayList<>();
        String sql = "SELECT * FROM activocategoria";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Activocategoria categoria = new Activocategoria();
                categoria.setIdactivocategoria(rs.getInt("idactivocategoria"));
                categoria.setCodigo(rs.getString("codigo"));
                categoria.setNombreactivocat(rs.getString("nombreactivocat"));
                categoria.setTasa_depreciacion(rs.getDouble("tasa_depreciacion"));
                categoria.setVida_util(rs.getInt("vida_util"));
                categorias.add(categoria);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categorias;
    }
}
