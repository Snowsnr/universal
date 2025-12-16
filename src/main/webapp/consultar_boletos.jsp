<%-- 
    Document   : consultar_boletos
    Created on : Dec 15, 2025, 5:09:13 PM
    Author     : snowsnr
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulta de Boletos y Paquetes - Universal</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>

    <style>
        /* ======================================= */
        /* CSS Base (Similar a los anteriores, color de consulta: Gris/Índigo) */
        /* ======================================= */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9; /* Fondo claro */
            color: #333;
            line-height: 1.6;
        }
        .container {
            max-width: 600px; /* Contenedor más pequeño para formulario simple */
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Encabezado */
        header {
            background-color: #3f51b5; /* Azul Índigo para Consulta */
            padding: 25px 20px;
            text-align: center;
            border-bottom: 5px solid #ff9800; /* Naranja para contraste */
            margin-bottom: 30px;
        }
        header h1 {
            margin: 0;
            font-size: 2.2em;
            color: white;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
        }
        .query-form {
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 1.0em;
        }
        
        /* Botón de envío */
        .submit-button {
            background-color: #00bcd4; /* Azul Cian/Turquesa */
            color: white;
            border: none;
            padding: 15px 25px;
            font-size: 1.1em;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s;
        }
        .submit-button:hover {
            background-color: #0097a7;
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
        
       
    </style>
</head>
<body>

    <header>
        <h1>🔍 Consultar Mis Compras</h1>
        <p>Introduce tu correo electrónico para ver tus boletos y paquetes.</p>
    </header>

    <div class="container">
        
        <a href="index.jsp" class="back-link">← Volver al Inicio</a>

        <form action="ConsultaBoleto" method="POST" class="query-form">

            <div class="form-group">
                <label for="email">Correo Electrónico (*)</label>
                <input type="email" id="email" name="email" required placeholder="tu.correo@dominio.com">
                <small>Debe ser el mismo correo usado para la compra.</small>
            </div>

            <div class="form-group">
                <label for="telefono">Teléfono (*)</label>
                <input type="tel" id="telefono" name="telefono" required placeholder="Ej: 555-123-4567">
            </div>

            <button type="submit" class="submit-button">
                Buscar Mis Compras
            </button>
            
        </form>
        
        

    </div>
    
    <script>
        window.onload = function() {
            <% if (request.getAttribute("mensaje") != null) { %>      
                Swal.fire({
                    icon: "warning",
                    title: "<%=request.getAttribute("mensaje")%>",
                    showConfirmButton: true
                });      
            <% } %>
        };
    </script>

</body>
</html>