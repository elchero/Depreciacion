package modelosDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import modelos.Asiento;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.List;

public class AsientoDAO {

    private static final String URL = "jdbc:mysql://conta1.c3miuy84i8m2.us-east-2.rds.amazonaws.com:3306/conta1";
    private static final String USER = "root";
    private static final String PASSWORD = "Elsalvador35";
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("my-persistence-unit");

    public void crearbd(Asiento asiento) throws SQLException {
        String sql = "INSERT INTO asiento (titulo, fecha, descripcion) VALUES (?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, asiento.getTitulo());
            stmt.setDate(2, new java.sql.Date(asiento.getFecha().getTime()));
            stmt.setString(3, asiento.getDescripcion());

            stmt.executeUpdate();
        }
    }

    public void crear(Asiento asiento) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(asiento);
        em.getTransaction().commit();
        em.close();
    }

    public void actualizar(Asiento asiento) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(asiento);
        em.getTransaction().commit();
        em.close();
    }

    public Asiento obtenerPorId(int id) {
        EntityManager em = emf.createEntityManager();
        Asiento asiento = em.find(Asiento.class, id);
        em.close();
        return asiento;
    }

    public List<Asiento> obtenerTodos() {
        EntityManager em = emf.createEntityManager();
        List<Asiento> asientos = em.createQuery("SELECT a FROM Asiento a", Asiento.class).getResultList();
        em.close();
        return asientos;
    }
}
