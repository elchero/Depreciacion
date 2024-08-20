package modelos;

import javax.persistence.*;

@Entity
@Table(name = "detalleasiento")
public class DetalleAsiento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "asiento_id", nullable = false)
    private Asiento asiento;

    @Column(name = "codigo_cuenta", nullable = false, length = 20)
    private String codigoCuenta;

    @Column(name = "nombre_cuenta", nullable = false, length = 100)
    private String nombreCuenta;

    @Column(name = "descripcion_cuenta")
    private String descripcionCuenta;

    @Column(name = "debe")
    private double debe;

    @Column(name = "haber")
    private double haber;

    @Column(name = "iva_debito_fiscal")
    private double ivaDebitoFiscal;

    @Column(name = "iva_credito_fiscal")
    private double ivaCreditoFiscal;

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Asiento getAsiento() {
        return asiento;
    }

    public void setAsiento(Asiento asiento) {
        this.asiento = asiento;
    }

    public String getCodigoCuenta() {
        return codigoCuenta;
    }

    public void setCodigoCuenta(String codigoCuenta) {
        this.codigoCuenta = codigoCuenta;
    }

    public String getNombreCuenta() {
        return nombreCuenta;
    }

    public void setNombreCuenta(String nombreCuenta) {
        this.nombreCuenta = nombreCuenta;
    }

    public String getDescripcionCuenta() {
        return descripcionCuenta;
    }

    public void setDescripcionCuenta(String descripcionCuenta) {
        this.descripcionCuenta = descripcionCuenta;
    }

    public double getDebe() {
        return debe;
    }

    public void setDebe(double debe) {
        this.debe = debe;
    }

    public double getHaber() {
        return haber;
    }

    public void setHaber(double haber) {
        this.haber = haber;
    }

    public double getIvaDebitoFiscal() {
        return ivaDebitoFiscal;
    }

    public void setIvaDebitoFiscal(double ivaDebitoFiscal) {
        this.ivaDebitoFiscal = ivaDebitoFiscal;
    }

    public double getIvaCreditoFiscal() {
        return ivaCreditoFiscal;
    }

    public void setIvaCreditoFiscal(double ivaCreditoFiscal) {
        this.ivaCreditoFiscal = ivaCreditoFiscal;
    }
}
