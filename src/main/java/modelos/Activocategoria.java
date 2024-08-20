package modelos;

/**
 *
 * @author vladi
 */
public class Activocategoria {
    private int idactivocategoria;
    private String codigo, nombreactivocat;
    private double tasa_depreciacion;
    private int vida_util;

    public Activocategoria() {
    }

    public Activocategoria(int idactivocategoria, String codigo, String nombreactivocat, double tasa_depreciacion, int vida_util) {
        this.idactivocategoria = idactivocategoria;
        this.codigo = codigo;
        this.nombreactivocat = nombreactivocat;
        this.tasa_depreciacion = tasa_depreciacion;
        this.vida_util = vida_util;
    }

    public Activocategoria(String codigo, String nombreactivocat, double tasa_depreciacion, int vida_util) {
        this.codigo = codigo;
        this.nombreactivocat = nombreactivocat;
        this.tasa_depreciacion = tasa_depreciacion;
        this.vida_util = vida_util;
    }

    public int getIdactivocategoria() {
        return idactivocategoria;
    }

    public void setIdactivocategoria(int idactivocategoria) {
        this.idactivocategoria = idactivocategoria;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombreactivocat() {
        return nombreactivocat;
    }

    public void setNombreactivocat(String nombreactivocat) {
        this.nombreactivocat = nombreactivocat;
    }

    public double getTasa_depreciacion() {
        return tasa_depreciacion;
    }

    public void setTasa_depreciacion(double tasa_depreciacion) {
        this.tasa_depreciacion = tasa_depreciacion;
    }

    public int getVida_util() {
        return vida_util;
    }

    public void setVida_util(int vida_util) {
        this.vida_util = vida_util;
    } 
}
