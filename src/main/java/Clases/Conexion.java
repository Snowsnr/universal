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
           
     //POSTGRE HOST, CON ESTE HACEN LA PULL REQUESTT
     
     /*
     String dbDriver = "org.postgresql.Driver";
     String dbURL = "jdbc:postgresql://ec2-100-26-73-144.compute-1.amazonaws.com/db3v6hean6n35q";
                          
             
     String dbUsername = "ipsrpxvnaqxiwm";
     String dbPassword = "45a8d512e214c8aec0d15935b70c9addc631a10c65bc23296d0e2e2bd0b2f0a0";
     Class.forName(dbDriver).newInstance();
     con = DriverManager.getConnection(dbURL,dbUsername, dbPassword);
     
     */
     //MYSQL LOCAL CAMBIEN LA CONTRASEÑA
     //
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
     //
     /* POSTGRE SQL LOCAL POR FAVOR USEN ESTA Y HAGAN TODOS LOS COMMMITS CON ESTA (llamenla MydeaLocal para que no tengan que cambiarlo aqui)
     
     String dbDriver = "org.postgresql.Driver";
     String dbURL = "jdbc:postgresql://localhost/MydeaLocal";
                          
             
     String dbUsername = "postgres";
     String dbPassword = "20232707";
     Class.forName(dbDriver).newInstance();
     con = DriverManager.getConnection(dbURL,dbUsername, dbPassword);
     
     */
      
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
