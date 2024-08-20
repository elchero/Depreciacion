package modelos;

/**
 *
 * @author vladi
 */
public class Activofamilia {

    private int idactivofamilia;
    private String codigo, nombreactivofami;
    private int idactivocategoria;
    private String nombreactivocat;

    public Activofamilia(int idactivofamilia, String codigo, String nombreactivofami) {
        this.idactivofamilia = idactivofamilia;
        this.codigo = codigo;
        this.nombreactivofami = nombreactivofami;
    }

    
    public Activofamilia() {
    }

    public Activofamilia(int idactivofamilia, String codigo, String nombreactivofami, int idactivocategoria) {
        this.idactivofamilia = idactivofamilia;
        this.codigo = codigo;
        this.nombreactivofami = nombreactivofami;
        this.idactivocategoria = idactivocategoria;
    }

    public Activofamilia(String codigo, String nombreactivofami, int idactivocategoria) {
        this.codigo = codigo;
        this.nombreactivofami = nombreactivofami;
        this.idactivocategoria = idactivocategoria;
    }

    public Activofamilia(String codigo, String nombreactivofami, int idactivocategoria, String nombreactivocat) {
        this.codigo = codigo;
        this.nombreactivofami = nombreactivofami;
        this.idactivocategoria = idactivocategoria;
        this.nombreactivocat = nombreactivocat;
    }
    

    public int getIdactivofamilia() {
        return idactivofamilia;
    }

    public void setIdactivofamilia(int idactivofamilia) {
        this.idactivofamilia = idactivofamilia;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombreactivofami() {
        return nombreactivofami;
    }

    public void setNombreactivofami(String nombreactivofami) {
        this.nombreactivofami = nombreactivofami;
    }

    public int getIdactivocategoria() {
        return idactivocategoria;
    }

    public void setIdactivocategoria(int idactivocategoria) {
        this.idactivocategoria = idactivocategoria;
    }

    public String getNombreactivocat() {
        return nombreactivocat;
    }

    public void setNombreactivocat(String nombreactivocat) {
        this.nombreactivocat = nombreactivocat;
    }
}
