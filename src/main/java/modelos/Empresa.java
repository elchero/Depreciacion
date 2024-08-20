package modelos;

/**
 *
 * @author vladi
 */
public class Empresa {

    private int idempresa;
    private String nombre_empresa, direccion,
            telefono, email, logo, mision, vision, descripcion;

    public Empresa() {
    }

    public Empresa(int idempresa, String nombre_empresa, String direccion, String telefono, String email, String logo, String mision, String vision, String descripcion) {
        this.idempresa = idempresa;
        this.nombre_empresa = nombre_empresa;
        this.direccion = direccion;
        this.telefono = telefono;
        this.email = email;
        this.logo = logo;
        this.mision = mision;
        this.vision = vision;
        this.descripcion = descripcion;
    }

    public Empresa(String nombre_empresa, String direccion, String telefono, String email, String logo, String mision, String vision, String descripcion) {
        this.nombre_empresa = nombre_empresa;
        this.direccion = direccion;
        this.telefono = telefono;
        this.email = email;
        this.logo = logo;
        this.mision = mision;
        this.vision = vision;
        this.descripcion = descripcion;
    }

    public int getIdempresa() {
        return idempresa;
    }

    public void setIdempresa(int idempresa) {
        this.idempresa = idempresa;
    }

    public String getNombre_empresa() {
        return nombre_empresa;
    }

    public void setNombre_empresa(String nombre_empresa) {
        this.nombre_empresa = nombre_empresa;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getMision() {
        return mision;
    }

    public void setMision(String mision) {
        this.mision = mision;
    }

    public String getVision() {
        return vision;
    }

    public void setVision(String vision) {
        this.vision = vision;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

}
