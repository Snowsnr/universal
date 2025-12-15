<%-- 
    Document   : index.jsp
    Created on : Dec 14, 2025, 5:34:28 PM
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
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Universal Orlando Resort - Inicio</title>
    
    <style>
        /* Estilos Generales */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #ffffff; /* FONDO BLANCO */
            color: #333; /* Texto oscuro para contraste */
            line-height: 1.6;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Encabezado Principal */
        header {
            background-color: #007bff;
            padding: 40px 20px;
            text-align: center;
            border-bottom: 5px solid #ffc107;
        }
        header h1 {
            margin: 0;
            font-size: 3em;
            color: white;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }
        header p {
            font-size: 1.2em;
            margin-top: 10px;
            color: white;
        }
        
        /* Sección de Introducción */
        .intro-section {
            padding: 40px 20px;
            text-align: center;
            color: #333; /* Texto oscuro */
        }
        .intro-section h2 {
            color: #007bff; /* Título azul */
            margin-bottom: 15px;
        }
        
        /* Navegación (Botones) */
        .navigation {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 30px;
            padding: 0 20px;
        }
        
        .nav-button {
            flex-basis: calc(25% - 20px);
            min-width: 250px;
            text-align: center;
            padding: 30px 20px;
            border-radius: 10px;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: white; /* Texto blanco en los botones de colores */
            font-weight: bold;
            font-size: 1.1em;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Sombra más sutil */
        }
        
        .nav-button:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
        }

        /* Estilos Específicos de Botones */
        .btn-theme { background-color: #1abc9c; } /* Verde/Turquesa */
        .btn-hotel { background-color: #9b59b6; } /* Púrpura */
        .btn-ticket { background-color: #f39c12; } /* Naranja/Oro */
        .btn-package { background-color: #e74c3c; } /* Rojo */

        /* Iconos */
        .nav-button span {
            display: block;
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        /* Pie de página */
        footer {
            text-align: center;
            padding: 20px;
            margin-top: 50px;
            border-top: 1px solid #ddd; /* Separador sutil */
            font-size: 0.9em;
            color: #666;
        }

        /* Media Queries para Responsive Design (móviles) */
        @media (max-width: 1080px) {
            .nav-button {
                flex-basis: calc(50% - 10px);
            }
        }
        @media (max-width: 580px) {
            .nav-button {
                flex-basis: 100%;
            }
        }
    </style>
</head>
<body>

    <header>
        <h1>UNIVERSAL ORLANDO RESORT</h1>
        <p>Tu puerta de entrada al mundo de la magia y la emoción.</p>
    </header>

    <div class="container">
        
        <section class="intro-section">
            <h2>Planifica tu Viaje Perfecto</h2>
            <p>Utiliza nuestra plataforma para explorar los parques temáticos de clase mundial, conocer las últimas atracciones, encontrar el hotel ideal y asegurar tus boletos y paquetes vacacionales con antelación.</p>
        </section>

        <section class="navigation">

            <a href="parques.jsp" class="nav-button btn-theme">
                <span>🎢</span>
                Ver Parques, Atracciones y Eventos
            </a>

            <a href="hospedajes.jsp" class="nav-button btn-hotel">
                <span>🏨</span>
                Buscar Opciones de Hospedaje
            </a>

            <a href="compra_boleto.jsp" class="nav-button btn-ticket">
                <span>🎟️</span>
                Comprar Boletos Individuales
            </a>

            <a href="compra_paquetes.jsp" class="nav-button btn-package">
                <span>🎁</span>
                Comprar Paquetes Vacacionales
            </a>

        </section>

        <section class="intro-section">
            <h2>Descubre Nuestros Mundos</h2>
            <p>Desde las tierras mágicas de Harry Potter en Islands of Adventure y Universal Studios, hasta la relajación y adrenalina de Volcano Bay, la aventura te espera en cada esquina. </p>
        </section>

    </div>

    <footer>
        <p>&copy; 2025 Plataforma de Planificación Universal (Datos simulados)</p>
    </footer>

</body>
</html>