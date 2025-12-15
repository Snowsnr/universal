/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Clases;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
        try {
            Statement stmt = con.createStatement();
            String sqlSelectCliente = "SELECT Cliente_ID FROM cliente WHERE email = '" + email + "'";
            int cliente_id = 0;
            ResultSet rr = stmt.executeQuery(sqlSelectCliente);

            while (rr.next()) {
                cliente_id = rr.getInt("Cliente_ID");
            }

            if (cliente_id == 0) {
                PreparedStatement psInsertCliente = con.prepareStatement(
                    "INSERT INTO cliente(nombre, email, telefono) VALUES(? , ? , ?)", 
                    Statement.RETURN_GENERATED_KEYS
                );
                psInsertCliente.setString(1, nombre);
                psInsertCliente.setString(2, email);
                psInsertCliente.setString(3, telefono);
                psInsertCliente.executeUpdate(); 

                ResultSet rsKeys = psInsertCliente.getGeneratedKeys();
                if (rsKeys.next()) {
                    cliente_id = rsKeys.getInt(1);
                }

                rsKeys.close();
                psInsertCliente.close();
            }
            
            rr.close();
            stmt.close();


            String sqlInsertCompra = "INSERT INTO compra_boleto(Cliente_ID, Boleto_ID, Nm_Boletos, Monto_Pagado, Metodo_Pago, Fecha_Compra) " +
                                     "VALUES(?, ?, ?, ?, ?, NOW());";

            PreparedStatement psInsertCompra = con.prepareStatement(sqlInsertCompra);

            psInsertCompra.setInt(1, cliente_id);         
            psInsertCompra.setInt(2, idBoleto);           
            psInsertCompra.setInt(3, numBoleto);          
            psInsertCompra.setDouble(4, monto);           
            psInsertCompra.setString(5, metodoPago);    

            psInsertCompra.executeUpdate(); 

            psInsertCompra.close();

            System.out.println("Compra de boleto registrada con éxito. Cliente ID: " + cliente_id);

        } catch (Exception e) {
            System.err.println("Error al procesar la Compra de Boleto: " + e);
            // Aquí podrías lanzar una excepción personalizada (throw new DAOException(e))
        }
    }
    
    // Asumiendo que esta función reside en tu clase DAO (ej: PaqueteDAO.java)
// Y asumiendo que 'con' (Connection) es una variable de instancia de esa clase.

public void CompraDePaquete(String nombre, String email, String telefono, int idPaquete, double monto, String fechaCheckin, String fechaCheckout, String metodoPago) {
        try {

            Statement stmt = con.createStatement();
            String sqlSelectCliente = "SELECT Cliente_ID FROM cliente WHERE email = '" + email + "'";
            int cliente_id = 0;

            ResultSet rr = stmt.executeQuery(sqlSelectCliente);

            while (rr.next()) {
                cliente_id = rr.getInt("Cliente_ID");
            }

            if (cliente_id == 0) {
                PreparedStatement psInsertCliente = con.prepareStatement(
                    "INSERT INTO cliente(nombre, email, telefono) VALUES(? , ? , ?)", 
                    Statement.RETURN_GENERATED_KEYS
                );
                psInsertCliente.setString(1, nombre);
                psInsertCliente.setString(2, email);
                psInsertCliente.setString(3, telefono);
                psInsertCliente.executeUpdate(); 

                ResultSet rsKeys = psInsertCliente.getGeneratedKeys();
                if (rsKeys.next()) {
                    cliente_id = rsKeys.getInt(1);
                }

                rsKeys.close();
                psInsertCliente.close();
            }

            rr.close();
            stmt.close();


            String sqlInsertCompra = "INSERT INTO Compra_Paquete("
                                   + "Cliente_ID, Paquete_ID, Fecha_Checkin, Fecha_Checkout, Monto_Total, Metodo_Pago, Fecha_Compra"
                                   + ") VALUES(?, ?, DATE(?), DATE(?), ?, ?, NOW());";

            PreparedStatement psInsertCompra = con.prepareStatement(sqlInsertCompra);


            psInsertCompra.setInt(1, cliente_id);           
            psInsertCompra.setInt(2, idPaquete);           

     
            psInsertCompra.setString(3, fechaCheckin);      
            psInsertCompra.setString(4, fechaCheckout);    

            psInsertCompra.setDouble(5, monto);            
            psInsertCompra.setString(6, metodoPago);      

            psInsertCompra.executeUpdate(); 

            psInsertCompra.close();

            System.out.println("Compra de paquete registrada con éxito. Cliente ID: " + cliente_id);

        } catch (Exception e) {
            System.err.println("Error al procesar la Compra de Paquete: " + e);

        }
    }
}
