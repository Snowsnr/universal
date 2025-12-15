/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.universal;

import Clases.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Usuario
 */
@WebServlet(name = "ComprarBoleto", urlPatterns = {"/ComprarBoleto"})
public class ComprarBoleto extends HttpServlet {

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
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Configurar la codificación para asegurar que caracteres especiales se lean correctamente
            request.setCharacterEncoding("UTF-8");

            String nombre = request.getParameter("nombrec"); 

            String email = request.getParameter("email");

            String telefono = request.getParameter("telefono"); 

            String boletoIdStr = request.getParameter("boleto_id"); 

            String nmBoletosStr = request.getParameter("nm_boletos");

            String metodoPago = request.getParameter("metodo_pago"); 
            
            String monto = request.getParameter("monto"); 
            
            Conexion con = new Conexion();
            Connection c;
            con.setCon();
            c=con.getCon();

            con.CompraDeBoleto(nombre, email, telefono, Integer.parseInt(boletoIdStr), Integer.parseInt(nmBoletosStr), metodoPago, Integer.parseInt(monto));

            try {
                c.close();
            } catch (SQLException ex) {

            }
            
            String mensaje="Tu compra ha sido realizada con exito";
            request.setAttribute("mensaje", mensaje);
            RequestDispatcher rd = request.getRequestDispatcher("compra_boleto.jsp");
            rd.forward(request, response);
            
            
            
            /*
            
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ComprarBoleto</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>nombre " + nombre + "</h1>");
            out.println("<h1>email " + email + "</h1>");
            out.println("<h1>telefono " + telefono + "</h1>");
            out.println("<h1>boleto " + boletoIdStr + "</h1>");
            out.println("<h1>num boletos " + nmBoletosStr + "</h1>");
            out.println("<h1>metodoPago " + metodoPago + "</h1>");
            out.println("<h1>monto " + monto + "</h1>");
            out.println("</body>");
            out.println("</html>");
            */
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
        processRequest(request, response);
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
        processRequest(request, response);
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
