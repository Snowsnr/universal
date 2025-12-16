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
@WebServlet(name = "CompraPaquete", urlPatterns = {"/CompraPaquete"})
public class CompraPaquete extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            String nombre = request.getParameter("nombre");
            String email = request.getParameter("email");
            String telefono = request.getParameter("telefono"); 


            String paqueteIdStr = request.getParameter("paquete_id");
            String montoPagadoStr = request.getParameter("monto_pagado");
            String metodoPago = request.getParameter("metodo_pago");

            String fechaCheckin = request.getParameter("fecha_checkin");
            String fechaCheckout = request.getParameter("fecha_checkout");


            int idPaquete = 0;
            double monto = 0.0;


                idPaquete = Integer.parseInt(paqueteIdStr);
                monto = Double.parseDouble(montoPagadoStr);


                Conexion con = new Conexion();
                Connection c;

                con.setCon();
                c = con.getCon();


                con.CompraDePaquete(nombre, email, telefono, idPaquete, monto, fechaCheckin, fechaCheckout, metodoPago);

                try {
                    c.close();
                } catch (SQLException ex) {

                }

                String mensaje = "¡Tu reserva de paquete ha sido realizada con éxito! Revisa tu email.";
                request.setAttribute("mensaje", mensaje);
                RequestDispatcher rd = request.getRequestDispatcher("compra_paquetes.jsp");
                rd.forward(request, response);
            
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
