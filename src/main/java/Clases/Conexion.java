/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Clases;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author Usuario
 */
public class Conexion {
    private Connection con;
    
    
    public Conexion(){
        
    }

    public Connection getCon() {
        return con;
    }

    public void setCon() {
       try{
     
     //MYSQL LOCAL CAMBIEN LA CONTRASEÑA
     /*
     String dbDriver = "com.mysql.jdbc.Driver";
     String dbURL = "jdbc:mysql://localhost:3306/";
                // Database name to access
     String dbName = "universal";
     String dbUsername = "root";
     String dbPassword = "Sn0w.2017";
     Class.forName(dbDriver).newInstance();
     con = DriverManager.getConnection(dbURL + dbName,
     dbUsername,
     dbPassword); 
     */
     
    String dbDriver = "com.mysql.cj.jdbc.Driver"; 
    
    // 2. La URL solo debe tener la dirección, puerto y nombre de la BD
    // Formato: jdbc:mysql://[HOST]:[PORT]/[DB_NAME]
    String connectionUrl = "jdbc:mysql://crossover.proxy.rlwy.net:50074/railway";
    
    // 3. Credenciales por separado
    String dbUsername = "root";
    String dbPassword = "FJFooPQsHISyzllZZapRkdwYVZqwouxp"; // Tu contraseña real

    // Cargar el driver
    Class.forName(dbDriver);
    
    // 4. Conectar pasando la URL limpia y las credenciales aparte
    // (Añadimos useSSL=false para evitar errores de certificados en pruebas)
    con = DriverManager.getConnection(connectionUrl + "?useSSL=false", dbUsername, dbPassword);

   
      } catch (Exception e ) {
            System.out.println("erore");
                System.err.println("Error"+e);
      }
    }
    
    public void CompraDeBoleto(String nombre, String email, String telefono, int idBoleto, int numBoleto, String metodoPago, double monto) {
    
        // 1. OBTENER EL ID DEL MÉTODO DE PAGO
        int metodoId = obtenerMetodoId(metodoPago);
        if (metodoId == -1) {
            System.err.println("Error: Método de pago '" + metodoPago + "' no encontrado en la base de datos. Compra abortada.");
            return; 
        }

        Statement stmt = null;
        ResultSet rr = null;
        PreparedStatement psInsertCliente = null;
        ResultSet rsKeys = null;
        PreparedStatement psInsertCompra = null;

        try {
            stmt = con.createStatement();
            String sqlSelectCliente = "SELECT Cliente_ID FROM cliente WHERE email = '" + email + "'";
            int cliente_id = 0;
            rr = stmt.executeQuery(sqlSelectCliente);

            while (rr.next()) {
                cliente_id = rr.getInt("Cliente_ID");
            }

            if (cliente_id == 0) {
                psInsertCliente = con.prepareStatement(
                    "INSERT INTO cliente(nombre, email, telefono) VALUES(? , ? , ?)", 
                    Statement.RETURN_GENERATED_KEYS
                );
                psInsertCliente.setString(1, nombre);
                psInsertCliente.setString(2, email);
                psInsertCliente.setString(3, telefono);
                psInsertCliente.executeUpdate(); 

                rsKeys = psInsertCliente.getGeneratedKeys();
                if (rsKeys.next()) {
                    cliente_id = rsKeys.getInt(1);
                }

                rsKeys.close();
                psInsertCliente.close();
            }

            // Cierre de recursos de la primera parte
            rr.close();
            stmt.close();

            // 2. INSERTAR LA COMPRA USANDO METODO_ID (int)
            // CAMBIO: La columna ahora es Metodo_ID
            String sqlInsertCompra = "INSERT INTO compra_boleto(Cliente_ID, Boleto_ID, Nm_Boletos, Monto_Pagado, Metodo_ID, Fecha_Compra) " +
                                     "VALUES(?, ?, ?, ?, ?, NOW());";

            psInsertCompra = con.prepareStatement(sqlInsertCompra);

            psInsertCompra.setInt(1, cliente_id);        
            psInsertCompra.setInt(2, idBoleto);         
            psInsertCompra.setInt(3, numBoleto);        
            psInsertCompra.setDouble(4, monto);         

            // CAMBIO: Se usa ps.setInt y la variable metodoId
            psInsertCompra.setInt(5, metodoId);      

            psInsertCompra.executeUpdate(); 

            psInsertCompra.close();

            System.out.println("Compra de boleto registrada con éxito. Cliente ID: " + cliente_id);

        } catch (Exception e) {
            System.err.println("Error al procesar la Compra de Boleto: " + e);
            // Manejo de cierre de recursos en caso de error
        } finally {
            try {
                if (rsKeys != null) rsKeys.close();
                if (psInsertCliente != null) psInsertCliente.close();
                if (rr != null) rr.close();
                if (stmt != null) stmt.close();
                if (psInsertCompra != null) psInsertCompra.close();
            } catch (SQLException ignore) {}
        }
    }


    public void CompraDePaquete(String nombre, String email, String telefono, int idPaquete, double monto, String fechaCheckin, String fechaCheckout, String metodoPago) {

        // 1. OBTENER EL ID DEL MÉTODO DE PAGO
        int metodoId = obtenerMetodoId(metodoPago);
        if (metodoId == -1) {
            System.err.println("Error: Método de pago '" + metodoPago + "' no encontrado en la base de datos. Compra abortada.");
            return; 
        }

        Statement stmt = null;
        ResultSet rr = null;
        PreparedStatement psInsertCliente = null;
        ResultSet rsKeys = null;
        PreparedStatement psInsertCompra = null;

        try {
            stmt = con.createStatement();
            String sqlSelectCliente = "SELECT Cliente_ID FROM cliente WHERE email = '" + email + "'";
            int cliente_id = 0;

            rr = stmt.executeQuery(sqlSelectCliente);

            while (rr.next()) {
                cliente_id = rr.getInt("Cliente_ID");
            }

            if (cliente_id == 0) {
                psInsertCliente = con.prepareStatement(
                    "INSERT INTO cliente(nombre, email, telefono) VALUES(? , ? , ?)", 
                    Statement.RETURN_GENERATED_KEYS
                );
                psInsertCliente.setString(1, nombre);
                psInsertCliente.setString(2, email);
                psInsertCliente.setString(3, telefono);
                psInsertCliente.executeUpdate(); 

                rsKeys = psInsertCliente.getGeneratedKeys();
                if (rsKeys.next()) {
                    cliente_id = rsKeys.getInt(1);
                }

                rsKeys.close();
                psInsertCliente.close();
            }

            // Cierre de recursos de la primera parte
            rr.close();
            stmt.close();

            // 2. INSERTAR LA COMPRA USANDO METODO_ID (int)
            // CAMBIO: La columna ahora es Metodo_ID
            String sqlInsertCompra = "INSERT INTO compra_paquete("
                                   + "Cliente_ID, Paquete_ID, Fecha_Checkin, Fecha_Checkout, Monto_Total, Metodo_ID, Fecha_Compra"
                                   + ") VALUES(?, ?, DATE(?), DATE(?), ?, ?, NOW());";

            psInsertCompra = con.prepareStatement(sqlInsertCompra);


            psInsertCompra.setInt(1, cliente_id);           
            psInsertCompra.setInt(2, idPaquete);            

            psInsertCompra.setString(3, fechaCheckin);       
            psInsertCompra.setString(4, fechaCheckout);     

            psInsertCompra.setDouble(5, monto);             

            // CAMBIO: Se usa ps.setInt y la variable metodoId
            psInsertCompra.setInt(6, metodoId);      

            psInsertCompra.executeUpdate(); 

            psInsertCompra.close();

            System.out.println("Compra de paquete registrada con éxito. Cliente ID: " + cliente_id);

        } catch (Exception e) {
            System.err.println("Error al procesar la Compra de Paquete: " + e);

        } finally {
            // Manejo de cierre de recursos
            try {
                if (rsKeys != null) rsKeys.close();
                if (psInsertCliente != null) psInsertCliente.close();
                if (rr != null) rr.close();
                if (stmt != null) stmt.close();
                if (psInsertCompra != null) psInsertCompra.close();
            } catch (SQLException ignore) {}
        }
    }

    public int ConsultarCliente(String email, String telefono){
        int cliente_id = 0;
        try {
            Statement stmt = con.createStatement();
            String sqlSelectCliente = "SELECT Cliente_ID FROM cliente WHERE email = '" + email + "' AND telefono='"+telefono+"'";
            

            ResultSet rr = stmt.executeQuery(sqlSelectCliente);

            while (rr.next()) {
                cliente_id = rr.getInt("Cliente_ID");
            }

            

        } catch (Exception e) {
            System.err.println("Error al procesar la Compra de Paquete: " + e);

        }
        return cliente_id;
    }
    
    public void EliminarBoleto(int id){
        try {
           Statement stmt = con.createStatement();
            String sql = "delete from compra_boleto where compra_id=?";
            

             PreparedStatement ps = con.prepareStatement(sql);
             ps.setInt(1, id);
             ps.executeUpdate(); 

           
        } catch (Exception e) {
            System.err.println("Error al procesar la Compra de Paquete: " + e);

        }

    }
    public int obtenerMetodoId(String nombreMetodo) {
        int metodoId = -1;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Usamos LIKE %...% para ser flexibles, o solo = si el JSP envía el nombre exacto.
            String sql = "SELECT Metodo_ID FROM Metodo_Pago WHERE Nombre_Metodo = ?";

            // Asumiendo que 'con' es la conexión activa de la clase.
            ps = con.prepareStatement(sql);
            ps.setString(1, nombreMetodo);

            rs = ps.executeQuery();

            if (rs.next()) {
                metodoId = rs.getInt("Metodo_ID");
            }

        } catch (Exception e) {
            System.err.println("Error al obtener Metodo_ID: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException ignore) { /* Ignorar errores al cerrar */ }
        }
        return metodoId;
    }
}
