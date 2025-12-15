<%-- 
    Document   : compra_boleto
    Created on : Dec 14, 2025, 7:17:22 PM
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.Conexion"%>
<%@page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comprar Boletos Individuales - Universal</title>
    
    <style>
        /* [Se mantiene el CSS anterior para el diseño de la página] */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #ffffff;
            color: #333;
            line-height: 1.6;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        header {
            background-color: #f39c12; 
            padding: 25px 20px;
            text-align: center;
            border-bottom: 5px solid #007bff;
            margin-bottom: 30px;
        }
        header h1 {
            margin: 0;
            font-size: 2.5em;
            color: white;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
        }
        .purchase-form {
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        fieldset {
            border: 1px solid #ced4da;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 5px;
        }
        legend {
            font-size: 1.2em;
            font-weight: bold;
            color: #007bff;
            padding: 0 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input, 
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .submit-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 15px 25px;
            font-size: 1.1em;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s;
        }
        .submit-button:hover {
            background-color: #218838;
        }
        .back-link {
            display: inline-block;
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
            margin-bottom: 40px;
            transition: background-color 0.3s;
        }
        .back-link:hover {
            background-color: #5a6268;
        }
        /* Fin de estilos CSS */
    </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>
</head>
<body>

    <header>
        <h1>Comprar Boletos Individuales 🎟️</h1>
        <p>Selecciona tu acceso y completa la información de contacto.</p>
    </header>

    <div class="container">
        
        <a href="index.jsp" class="back-link">← Volver al Inicio</a>

        <form action="ComprarBoleto" method="POST" class="purchase-form">

            <fieldset>
                <legend>1. Detalles del Cliente (Comprador)</legend>
                <div class="form-group"><label for="nombre">Nombre Completo (*)</label><input type="text" id="nombre" name="nombrec" required placeholder="Ej: Juan Pérez"></div>
                <div class="form-group"><label for="email">Email (*)</label><input type="email" id="email" name="email" required placeholder="ejemplo@dominio.com"></div>
                <div class="form-group"><label for="telefono">Teléfono</label><input type="tel" id="telefono" name="telefono" placeholder="Ej: 555-123-4567"></div>
            </fieldset>

            <fieldset>
                <legend>2. Selección del Boleto</legend>
                
                <div class="form-group">
                    <label for="boleto_id">Tipo de Boleto (*)</label>
                    <select id="boleto_id" name="boleto_id" required onchange="calcularMontoEstimado()" >
                        <option value="" data-precio="0">-- Seleccione un tipo de boleto --</option>
                        
                        <option value="1" data-precio="120.00">1 Día Base - $120.00</option>
                        <option value="5" data-precio="170.00">1 Día Park-to-Park (P-P) - $170.00</option>
                        <option value="3" data-precio="380.00">3 Días Park-to-Park (P-P) - $380.00</option>
                        <option value="10" data-precio="80.00">Volcano Bay 1 Día - $80.00</option>
                        
                    </select>
                </div>

                <div class="form-group">
                    <label for="nm_boletos">Cantidad de Boletos a Comprar (*)</label>
                    <input type="number" id="nm_boletos" name="nm_boletos" required min="1" max="10" value="1" onchange="calcularMontoEstimado()" onkeyup="calcularMontoEstimado()">
                    <small>Máximo 10 boletos por transacción.</small>
                </div>
                
            </fieldset>

            <fieldset>
                <legend>3. Pago</legend>

                <div class="form-group">
                    <label for="metodo_pago">Método de Pago (*)</label>
                    <select id="metodo_pago" name="metodo_pago" required>
                        <option value="">-- Seleccione el método --</option>
                        <option value="Tarjeta VISA">Tarjeta de Crédito / Débito (VISA)</option>
                        <option value="MasterCard">MasterCard / AMEX</option>
                        <option value="PayPal">PayPal</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Monto Total Estimado:</label>
                    <p style="font-size: 1.5em; font-weight: bold; color: #e74c3c;">$ <span id="monto_total_display">0.00</span> USD</p>
                    <small>Este es un estimado; el precio final se confirmará en el servidor.</small>
                </div>
            </fieldset>
            <input type="hidden" name="monto" id="monto" value=""/>
            <button type="submit" class="submit-button">
                Completar Compra y Pagar
            </button>
            
        </form>

    </div>

    <script>
        function calcularMontoEstimado() {
            // 1. Obtener elementos del DOM
            const selectBoleto = document.getElementById('boleto_id');
            const inputCantidad = document.getElementById('nm_boletos');
            const displayMonto = document.getElementById('monto_total_display');

            // 2. Obtener el precio base del boleto seleccionado
            // El precio se almacena en el atributo 'data-precio' de la opción elegida.
            const selectedOption = selectBoleto.options[selectBoleto.selectedIndex];
            const precioBase = parseFloat(selectedOption.getAttribute('data-precio') || 0);

            // 3. Obtener la cantidad de boletos
            const cantidad = parseInt(inputCantidad.value) || 0;

            // 4. Calcular el monto total
            let montoTotal = precioBase * cantidad;

            // 5. Formatear y mostrar el resultado
            // Formatear a dos decimales
            const montoFormateado = montoTotal.toFixed(2);
            
            // Actualizar el elemento de visualización
            document.getElementById('monto').value = montoTotal;
            displayMonto.textContent = montoFormateado;
        }

        // Ejecutar la función al cargar la página para inicializar el valor
        window.onload = calcularMontoEstimado;
    </script>

</body>
 <%
        if (request.getAttribute("mensaje") != null) {
    %>          
    <script>
        window.onload = function () {
            Swal.fire({
                icon: "success",
                title: "<%=request.getAttribute("mensaje")%>",
                showConfirmButton: false,
                timer: 5000
            });
        };
    </script>      
    <%
        }
    %>
</html>