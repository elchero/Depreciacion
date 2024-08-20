package modelosDAO;

import db.cn;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Activofamilia;

/**
 *
 * @author vladi
 */
public class ActivofamiliaDAO {

    private cn CN;
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    public ActivofamiliaDAO() throws ClassNotFoundException {
        CN = new cn();
    }

    public List<Activofamilia> listar() {
        ArrayList<Activofamilia> lista = new ArrayList<>();
        String sql = "SELECT af.idactivofamilia, af.codigo, af.nombreactivofami, ac.nombreactivocat "
                + "FROM activofamilia af "
                + "JOIN activocategoria ac ON af.idactivocategoria = ac.idactivocategoria";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Activofamilia familia = new Activofamilia();
                familia.setIdactivofamilia(rs.getInt("idactivofamilia"));
                familia.setCodigo(rs.getString("codigo"));
                familia.setNombreactivofami(rs.getString("nombreactivofami"));
                familia.setNombreactivocat(rs.getString("nombreactivocat"));
                lista.add(familia);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    //...
    public Activofamilia ListarById(int id) {
        Activofamilia familia = new Activofamilia();
        String sql = "SELECT af.idactivofamilia, af.codigo, af.nombreactivofami, ac.nombreactivocat "
                + "FROM activofamilia af "
                + "JOIN activocategoria ac ON af.idactivocategoria = ac.idactivocategoria "
                + "WHERE af.idactivofamilia = ?";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                familia.setIdactivofamilia(rs.getInt("idactivofamilia"));
                familia.setCodigo(rs.getString("codigo"));
                familia.setNombreactivofami(rs.getString("nombreactivofami"));
                familia.setNombreactivocat(rs.getString("nombreactivocat"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return familia;
    }

    //Agregar una nueva ActivoFamilia
    public boolean agregar(Activofamilia familia) {
        String sql = "INSERT INTO activofamilia(codigo, nombreactivofami, idactivocategoria)"
                + "VALUES(?,?,?)";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);

            ps.setString(1, familia.getCodigo());
            ps.setString(2, familia.getNombreactivofami());
            ps.setInt(3, familia.getIdactivocategoria());
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            return false;
        }
    }

    //Actualizar la informacion de familia
    public boolean actualizar(Activofamilia familia) {
        String sql = "UPDATE activofamilia SET codigo=?, nombreactivofami=?"
                + " WHERE idactivofamilia = ?";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setString(1, familia.getCodigo());
            ps.setString(2, familia.getNombreactivofami());
           // ps.setInt(3, familia.getIdactivocategoria());
            ps.setInt(3, familia.getIdactivofamilia());
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean eliminar(int idactivofamilia) {
        String sql = "DELETE FROM activofamilia WHERE idactivofamilia=?";
        try (Connection con = CN.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idactivofamilia);
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Activofamilia> obtenerFamiliasPorCategoria(int categoriaId) {
        List<Activofamilia> familias = new ArrayList<>();
        String sql = "SELECT * FROM activofamilia WHERE idactivocategoria = ?";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setInt(1, categoriaId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Activofamilia familia = new Activofamilia();
                familia.setIdactivofamilia(rs.getInt("idactivofamilia"));
                familia.setCodigo(rs.getString("codigo"));
                familia.setNombreactivofami(rs.getString("nombreactivofami"));
                familia.setIdactivocategoria(rs.getInt("idactivocategoria"));
                familias.add(familia);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return familias;
    }
}
