package modelos;

import java.sql.Date;

/**
 *
 * @author vladi
 */
public class Activo {

    private int idactivo;
    private int idempresa;
    private String nombre_empresa;
    private int idactivofamilia;
    private String nombreactivofami;
    private String descripcion, marca, modelo, serie;
    private double costo;
    private Date fecha_adquisicion;
    private double valor_residual;
    private int idactivocategoria;

    public Activo() {
    }

    public Activo(int idactivo, int idempresa, int idactivofamilia, String descripcion, String marca, String modelo, String serie, double costo, Date fecha_adquisicion, double valor_residual) {
        this.idactivo = idactivo;
        this.idempresa = idempresa;
        this.idactivofamilia = idactivofamilia;
        this.descripcion = descripcion;
        this.marca = marca;
        this.modelo = modelo;
        this.serie = serie;
        this.costo = costo;
        this.fecha_adquisicion = fecha_adquisicion;
        this.valor_residual = valor_residual;
    }

    public Activo(int idempresa, int idactivofamilia, String descripcion, String marca, String modelo, String serie, double costo, Date fecha_adquisicion, double valor_residual) {
        this.idempresa = idempresa;
        this.idactivofamilia = idactivofamilia;
        this.descripcion = descripcion;
        this.marca = marca;
        this.modelo = modelo;
        this.serie = serie;
        this.costo = costo;
        this.fecha_adquisicion = fecha_adquisicion;
        this.valor_residual = valor_residual;
    }

    public Activo(int idempresa, String nombre_empresa, int idactivofamilia, String nombreactivofami, String descripcion, String marca, String modelo, String serie, double costo, Date fecha_adquisicion, double valor_residual) {
        this.idempresa = idempresa;
        this.nombre_empresa = nombre_empresa;
        this.idactivofamilia = idactivofamilia;
        this.nombreactivofami = nombreactivofami;
        this.descripcion = descripcion;
        this.marca = marca;
        this.modelo = modelo;
        this.serie = serie;
        this.costo = costo;
        this.fecha_adquisicion = fecha_adquisicion;
        this.valor_residual = valor_residual;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getNombre_empresa() {
        return nombre_empresa;
    }

    public void setNombre_empresa(String nombre_empresa) {
        this.nombre_empresa = nombre_empresa;
    }

    public String getNombreactivofami() {
        return nombreactivofami;
    }

    public void setNombreactivofami(String nombreactivofami) {
        this.nombreactivofami = nombreactivofami;
    }

    public int getIdactivo() {
        return idactivo;
    }

    public void setIdactivo(int idactivo) {
        this.idactivo = idactivo;
    }

    public int getIdempresa() {
        return idempresa;
    }

    public void setIdempresa(int idempresa) {
        this.idempresa = idempresa;
    }

    public int getIdactivofamilia() {
        return idactivofamilia;
    }

    public void setIdactivofamilia(int idactivofamilia) {
        this.idactivofamilia = idactivofamilia;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public String getSerie() {
        return serie;
    }

    public void setSerie(String serie) {
        this.serie = serie;
    }

    public double getCosto() {
        return costo;
    }

    public void setCosto(double costo) {
        this.costo = costo;
    }

    public Date getFecha_adquisicion() {
        return fecha_adquisicion;
    }

    public void setFecha_adquisicion(Date fecha_adquisicion) {
        this.fecha_adquisicion = fecha_adquisicion;
    }

    public double getValor_residual() {
        return valor_residual;
    }

    public void setValor_residual(double valor_residual) {
        this.valor_residual = valor_residual;
    }

    public int getIdactivocategoria() {
        return idactivocategoria;
    }

    public void setIdactivocategoria(int idactivocategoria) {
        this.idactivocategoria = idactivocategoria;
    }

}
