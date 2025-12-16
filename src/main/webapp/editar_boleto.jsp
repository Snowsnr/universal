<%-- 
    Document   : editar_boleto
    Created on : Dec 15, 2025
    Author     : snowsnr / Gemini (Adaptación y corrección)
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="Clases.Conexion"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Compra de Boleto - Universal</title>

    <link rel="stylesheet" href="css/sweetalert2.min.css">
    <script src="js/sweetalert2.min.js"></script>

    <style>
        /* CSS se mantiene igual para mantener el estilo */
        /* ======================================= */
        /* CSS General */
        /* ======================================= */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }
        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }
        header h1 {
            color: #3f51b5;
            text-align: center;
            margin-bottom: 25px;
            border-bottom: 3px solid #ff9800;
            padding-bottom: 10px;
        }

        /* Estilos de Formularios y Campos */
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        .form-group input[type="text"]:read-only,
        .form-group input[type="date"]:read-only {
            background-color: #e9ecef; /* Color gris suave para campos fijos */
            color: #6c757d;
            cursor: default;
        }
        .form-group input[type="number"],
        .form-group input[type="text"],
        .form-group input[type="date"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 1em;
        }
        .form-group input[type="number"] {
            max-width: 150px; /* Limitar ancho del campo de cantidad */
        }
        
        /* Contenedor de Resultado Dinámico */
        #resultado-dinamico {
            margin-top: 20px;
            padding: 15px;
            border-radius: 8px;
            font-weight: bold;
            text-align: center;
            transition: all 0.3s;
        }
        .reembolso {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .cargo {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .neutro {
            background-color: #ffeeba;
            color: #856404;
            border: 1px solid #ffc107;
        }

        /* Botón de Guardar */
        .submit-button {
            background-color: #4CAF50; /* Verde */
            color: white;
            border: none;
            padding: 15px 25px;
            font-size: 1.1em;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
            transition: background-color 0.3s;
        }
        .submit-button:hover {
            background-color: #45a049;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: #3f51b5;
            text-decoration: none;
            font-weight: bold;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%
    // Inicialización de variables para la lógica de la página
    String idCompraStr = (String) request.getAttribute("id");
    int idCompra = 0;
    
    String nombreBoleto = "N/A";
    int cantidadActual = 0;
    double precioUnitario = 0.0;
    String fechaCompra = "";
    String metodoPago = "N/A";
    
    // Conexión y recursos
    Conexion con = null;
    Connection c = null;
    PreparedStatement ps = null;
    ResultSet r = null;

   
        if (idCompraStr != null) {
            idCompra = Integer.parseInt(idCompraStr);
        } else {
            throw new IllegalArgumentException("ID de compra no proporcionado.");
        }
        
        con = new Conexion();
        con.setCon();
        c = con.getCon();

        // 1. Consulta SQL para obtener todos los datos necesarios
        // ¡Importante! Seleccionar precio_base (precio unitario) y nm_boletos (cantidad actual)
        String sql = "SELECT c.Nm_Boletos, b.tipo_boleto, b.precio_base, c.Fecha_Compra, m.Nombre_Metodo "
                   + "FROM compra_boleto c "
                   + "INNER JOIN boleto b ON c.Boleto_ID = b.Boleto_ID "
                   + "INNER JOIN Metodo_Pago m ON c.Metodo_ID = m.Metodo_ID "
                   + "WHERE c.Compra_ID = ?";
                   
        ps = c.prepareStatement(sql);
        ps.setInt(1, idCompra);
        r = ps.executeQuery();
        
        if (r.next()) {
            // Asignación de valores
            nombreBoleto = r.getString("tipo_boleto");
            cantidadActual = r.getInt("Nm_Boletos");
            precioUnitario = r.getDouble("precio_base"); // **CORREGIDO: Usamos el precio unitario del boleto**
            fechaCompra = String.valueOf(r.getDate("Fecha_Compra"));
            metodoPago = r.getString("Nombre_Metodo");
        } else {
             // Esto puede ocurrir si el ID de compra no existe
             System.err.println("Advertencia: Compra ID " + idCompra + " no encontrada.");
        }
        
    
    
%>

    <div class="container">
        <header>
            <h1>✏️ Editar Compra de Boleto</h1>
            <p style="text-align: center; color: #3f51b5;">Compra ID: **<%= idCompraStr != null ? idCompraStr : "N/A" %>**</p>
        </header>

        <form action="ActualizarBoleto" method="POST" onsubmit="return validarCantidad()">
            
            <input type="hidden" name="id_compra" value="<%= idCompraStr != null ? idCompraStr : "" %>"/>
            <input type="hidden" id="precio_unitario_hidden" value="<%= precioUnitario %>"/>
            <input type="hidden" id="cantidad_inicial_hidden" value="<%= cantidadActual %>"/>

            <fieldset>
                <legend>Detalles Fijos de la Compra</legend>
                <div class="form-group">
                    <label>Tipo de Boleto</label>
                    <input type="text" value="<%= nombreBoleto %>" readonly>
                </div>
                <div class="form-group">
                    <label>Método de Pago</label>
                    <input type="text" value="<%= metodoPago %>" readonly>
                </div>
                <div class="form-group">
                    <label>Fecha de Compra</label>
                    <input type="date" value="<%= fechaCompra %>" readonly>
                </div>
            </fieldset>

            <fieldset>
                <legend>Cantidad a Modificar</legend>
                <div class="form-group">
                    <label for="nueva_cantidad">Nueva Cantidad de Boletos (*)</label>
                    <input type="number" id="nueva_cantidad" name="nueva_cantidad" 
                           value="<%= cantidadActual > 0 ? cantidadActual : 1 %>" 
                           min="1" required oninput="calcularCambio()">
                </div>

                <div id="resultado-dinamico" class="neutro">
                    Ingresa la nueva cantidad para calcular el cambio.
                </div>
                
                <input type="hidden" id="monto_cambio_hidden" name="monto_cambio" value="0.00"/>

            </fieldset>
            
            <button type="submit" class="submit-button">
                Guardar Cambios
            </button>
                      <input type="hidden" id="id_cliente" name="id_cliente" value="<%=request.getAttribute("idc")%>"/>     
        </form>

        <a href="consultar_boletos.jsp" class="back-link">Volver</a>

    </div>

    <script>
        // JS utiliza los campos ocultos corregidos
        const precioUnitario = parseFloat(document.getElementById('precio_unitario_hidden').value);
        const cantidadInicial = parseInt(document.getElementById('cantidad_inicial_hidden').value);
        const inputNuevaCantidad = document.getElementById('nueva_cantidad');
        const resultadoDiv = document.getElementById('resultado-dinamico');
        const hiddenMontoCambio = document.getElementById('monto_cambio_hidden');

        // Función para validar que la cantidad no sea menor a 1
        function validarCantidad() {
            const nuevaCantidad = parseInt(inputNuevaCantidad.value);
            if (nuevaCantidad < 1) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error de Cantidad',
                    text: 'La cantidad mínima de boletos debe ser 1.',
                    confirmButtonColor: '#dc3545'
                });
                return false;
            }
            return true;
        }

        // Función principal para calcular el cambio dinámicamente
        // Función principal para calcular el cambio dinámicamente
function calcularCambio() {
    const nuevaCantidad = parseInt(inputNuevaCantidad.value);
    
    if (isNaN(nuevaCantidad) || nuevaCantidad < 1) {
        resultadoDiv.textContent = "La cantidad debe ser un número positivo.";
        resultadoDiv.className = 'neutro';
        hiddenMontoCambio.value = "0.00";
        return;
    }
    
    // Cantidad modificada (puede ser positivo o negativo)
    const diferenciaCantidad = nuevaCantidad - cantidadInicial;
    
    // Monto de la transacción (positivo: cargo, negativo: reembolso)
    const montoCambio = diferenciaCantidad * precioUnitario;
    
    const montoAbsoluto = Math.abs(montoCambio).toFixed(2);
    
    // Actualizar el campo oculto
    hiddenMontoCambio.value = montoCambio.toFixed(2);

    if (diferenciaCantidad < 0) {
        // REEMBOLSO (quitó boletos) - CORREGIDO: Usando concatenación (+)
        resultadoDiv.textContent = "Se le reembolsará: $" + montoAbsoluto + " USD (" + Math.abs(diferenciaCantidad) + " boleto(s)).";
        resultadoDiv.className = 'reembolso';
        
    } else if (diferenciaCantidad > 0) {
        // CARGO ADICIONAL (agregó boletos) - CORREGIDO: Usando concatenación (+)
        resultadoDiv.textContent = "Se le cargará: $" + montoAbsoluto + " USD por " + diferenciaCantidad + " boleto(s) adicional(es).";
        resultadoDiv.className = 'cargo';
        
    } else {
        // SIN CAMBIO
        resultadoDiv.textContent = "No hay cambios en la cantidad de boletos.";
        resultadoDiv.className = 'neutro';
    }
}

        // Ejecutar cálculo al cargar la página para mostrar el estado inicial
        window.onload = function() {
            calcularCambio();

            // Muestra mensaje de éxito/error después de redirigir del Servlet de Actualización
            <% if (request.getAttribute("alerta") != null) { %>      
                Swal.fire({
                    icon: "info",
                    title: "<%=request.getAttribute("alerta")%>",
                    showConfirmButton: true
                });      
            <% } %>
        };
    </script>

</body>
</html>