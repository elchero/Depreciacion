package clases;

/**
 *
 * @author vladi
 */
public class Depreciacion {

    private String anio, mes, dia, fecha;
    private String nombreactivofami, marca;
    private double depreciacionAnual, depreciacionMensual, depreciacionDiaria;
    private double depreciacionAcumulada;
    private double valorEnLibro;

    public String getAnio() {
        return anio;
    }

    public void setAnio(String anio) {
        this.anio = anio;
    }

    public String getNombreactivofami() {
        return nombreactivofami;
    }

    public void setNombreactivofami(String nombreactivofami) {
        this.nombreactivofami = nombreactivofami;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public double getDepreciacionAnual() {
        return depreciacionAnual;
    }

    public void setDepreciacionAnual(double depreciacionAnual) {
        this.depreciacionAnual = depreciacionAnual;
    }

    public double getDepreciacionAcumulada() {
        return depreciacionAcumulada;
    }

    public void setDepreciacionAcumulada(double depreciacionAcumulada) {
        this.depreciacionAcumulada = depreciacionAcumulada;
    }

    public double getValorEnLibro() {
        return valorEnLibro;
    }

    public void setValorEnLibro(double valorEnLibro) {
        this.valorEnLibro = valorEnLibro;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getMes() {
        return mes;
    }

    public void setMes(String mes) {
        this.mes = mes;
    }

    public double getDepreciacionMensual() {
        return depreciacionMensual;
    }

    public void setDepreciacionMensual(double depreciacionMensual) {
        this.depreciacionMensual = depreciacionMensual;
    }

    public String getDia() {
        return dia;
    }

    public void setDia(String dia) {
        this.dia = dia;
    }

    public double getDepreciacionDiaria() {
        return depreciacionDiaria;
    }

    public void setDepreciacionDiaria(double depreciacionDiaria) {
        this.depreciacionDiaria = depreciacionDiaria;
    }

}
