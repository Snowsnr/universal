/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.universal;

import Clases.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author snowsnr
 */
@WebServlet(name = "ActualizarBoleto", urlPatterns = {"/ActualizarBoleto"})
public class ActualizarBoleto extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
           
        request.setCharacterEncoding("UTF-8");
        
        
        String mensajeAlerta = "";
        String tipoAlerta = "error"; 

        Connection conn = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psSelect = null;
        
        try {
            
            String idCompraStr = request.getParameter("id_compra");
            int nuevaCantidad = Integer.parseInt(request.getParameter("nueva_cantidad"));
            double montoCambio = Double.parseDouble(request.getParameter("monto_cambio")); 

            if (idCompraStr == null || idCompraStr.isEmpty()) {
                throw new IllegalArgumentException("ID de compra no puede ser nulo.");
            }
            int idCompra = Integer.parseInt(idCompraStr);
            
            
            Conexion con = new Conexion();
            con.setCon();
            conn = con.getCon();
            
            
            String sqlUpdate = "UPDATE compra_boleto SET Nm_Boletos = ?, Monto_Pagado = Monto_Pagado + ? WHERE Compra_ID = ?";
            
            psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setInt(1, nuevaCantidad);
            psUpdate.setDouble(2, montoCambio); 
            psUpdate.setInt(3, idCompra);

            int filasAfectadas = psUpdate.executeUpdate();

            if (filasAfectadas > 0) {
                mensajeAlerta = "¡Éxito! La compra ID " + idCompra + " fue actualizada a " + nuevaCantidad + " boletos.";
                tipoAlerta = "success";
                
                if (montoCambio > 0) {
                    mensajeAlerta += " Se generó un cargo de $" + String.format("%.2f", montoCambio) + " USD.";
                } else if (montoCambio < 0) {
                    mensajeAlerta += " Se procesó un reembolso de $" + String.format("%.2f", Math.abs(montoCambio)) + " USD.";
                } else {
                    mensajeAlerta += " No hubo cambio en el monto pagado.";
                }
                
            } else {
                mensajeAlerta = "Advertencia: No se encontró la compra con ID " + idCompra + " o no se aplicaron cambios.";
                tipoAlerta = "warning";
            }
            
        } catch (NumberFormatException e) {
            mensajeAlerta = "Error de formato: La cantidad o el monto no son números válidos.";
            System.err.println("Error de formato: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            mensajeAlerta = "Error de parámetro: " + e.getMessage();
            System.err.println("Error de parámetro: " + e.getMessage());
        } catch (Exception e) {
            mensajeAlerta = "Ocurrió un error inesperado: " + e.getMessage();
            System.err.println("Error inesperado: " + e.getMessage());
        } finally {
            // 5. Cerrar recursos de la DB
            if (psUpdate != null) {
                psUpdate.close();
            } // Ignorar errores al cerrar
            if (psSelect != null) psSelect.close();
            if (conn != null) conn.close();
        }
        String id = request.getParameter("id_cliente");
         request.setAttribute("id", id);
         request.setAttribute("mensaje", mensajeAlerta);
        request.getRequestDispatcher("boletos.jsp").forward(request, response);
    }
        }
    

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ActualizarBoleto.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ActualizarBoleto.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
