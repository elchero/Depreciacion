package modelosDAO;

import db.cn;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import modelos.Empresa;

/**
 *
 * @author vladi
 */
public class EmpresaDAO {

    private cn CN;
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    public EmpresaDAO() throws ClassNotFoundException {
        CN = new cn();
    }

    public Empresa Listar(int id) {
        Empresa empresa = new Empresa();
        String sql = "SELECT * FROM empresa WHERE idempresa=?";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                empresa.setIdempresa(rs.getInt("idempresa"));
                empresa.setNombre_empresa(rs.getString("nombre_empresa"));
                empresa.setDireccion(rs.getString("direccion"));
                empresa.setTelefono(rs.getString("telefono"));
                empresa.setEmail(rs.getString("email"));
                empresa.setLogo(rs.getString("logo"));
                empresa.setMision(rs.getString("mision"));
                empresa.setVision(rs.getString("vision"));
                empresa.setDescripcion(rs.getString("descripcion"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return empresa;
    }

    //Actualizar la informacion de empresa
    public boolean actualizar(Empresa empresa) {
        String sql = "UPDATE empresa SET nombre_empresa=?, direccion=?, telefono=?, email=?, logo=?,"
                + "mision=?, vision=?, descripcion=?"
                + " WHERE idempresa=?";
        try {
            con = CN.getCon();
            ps = con.prepareStatement(sql);
            ps.setString(1, empresa.getNombre_empresa());
            ps.setString(2, empresa.getDireccion());
            ps.setString(3, empresa.getTelefono());
            ps.setString(4, empresa.getEmail());
            ps.setString(5, empresa.getLogo());
            ps.setString(6, empresa.getMision());
            ps.setString(7, empresa.getVision());
            ps.setString(8, empresa.getDescripcion());
            ps.setInt(9, empresa.getIdempresa());
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
