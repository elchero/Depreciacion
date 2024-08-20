package modelosDAO;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import modelos.DetalleAsiento;

public class DetalleAsientoDAO {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("my-persistence-unit");

    public void crear(DetalleAsiento detalleAsiento) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(detalleAsiento);
        em.getTransaction().commit();
        em.close();
    }

    public List<DetalleAsiento> obtenerPorAsientoId(int asientoId) {
        EntityManager em = emf.createEntityManager();
        List<DetalleAsiento> detalles = em.createQuery("SELECT d FROM DetalleAsiento d WHERE d.asiento.id = :asientoId", DetalleAsiento.class)
                .setParameter("asientoId", asientoId)
                .getResultList();
        em.close();
        return detalles;
    }
}
