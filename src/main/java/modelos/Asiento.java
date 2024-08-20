package modelos;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "asiento")
public class Asiento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "titulo", nullable = false, length = 100)
    private String titulo;

    @Column(name = "fecha", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fecha;

    @Column(name = "descripcion")
    private String descripcion;

    @Column(name = "total_debe", nullable = false)
    private double totalDebe;

    @Column(name = "total_haber", nullable = false)
    private double totalHaber;

    @OneToMany(mappedBy = "asiento", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<DetalleAsiento> detalles;

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getTotalDebe() {
        return totalDebe;
    }

    public void setTotalDebe(double totalDebe) {
        this.totalDebe = totalDebe;
    }

    public double getTotalHaber() {
        return totalHaber;
    }

    public void setTotalHaber(double totalHaber) {
        this.totalHaber = totalHaber;
    }

    public List<DetalleAsiento> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<DetalleAsiento> detalles) {
        this.detalles = detalles;
    }
}
