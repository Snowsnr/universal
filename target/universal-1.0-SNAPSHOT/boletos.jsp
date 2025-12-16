<%-- 
    Document   : boletos
    Created on : Dec 15, 2025, 5:16:23 PM
    Author     : snowsnr
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="Clases.Conexion"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tus Compras Registradas - Universal</title>
    
    

    <style>
        /* ======================================= */
        /* CSS Base y Tarjetas de Resultado */
        /* ======================================= */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
            line-height: 1.6;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Encabezado */
        header {
            background-color: #3f51b5; 
            padding: 25px 20px;
            text-align: center;
            border-bottom: 5px solid #ff9800; 
            margin-bottom: 30px;
        }
        header h1 {
            margin: 0;
            font-size: 2.5em;
            color: white;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
        }
        
        /* Tarjeta de Boleto Individual */
        .boleto-card {
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        /* Columna de Información */
        .boleto-info {
            flex-grow: 1;
        }
        .boleto-info h3 {
            color: #3f51b5;
            margin-top: 0;
            border-bottom: 2px solid #ff9800;
            padding-bottom: 5px;
        }
        .boleto-info p {
            margin: 5px 0;
            font-size: 0.95em;
        }
        .boleto-info strong {
            display: inline-block;
            min-width: 120px;
            color: #555;
        }
        
        /* Columna de Acciones (Formularios) */
        .boleto-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
            padding-left: 20px;
        }
        .boleto-actions form {
            margin: 0;
        }

        /* Estilos de Botones */
        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 120px; /* Ancho fijo para botones */
            font-weight: bold;
            transition: background-color 0.2s;
        }
        .btn-edit {
            background-color: #00bcd4; /* Azul Cian */
            color: white;
        }
        .btn-edit:hover {
            background-color: #0097a7;
        }
        .btn-delete {
            background-color: #dc3545; /* Rojo */
            color: white;
        }
        .btn-delete:hover {
            background-color: #c82333;
        }

        .back-link {
            /* Mismo estilo que antes */
            display: inline-block;
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-bottom: 20px;
        }
        .back-link:hover {
            background-color: #5a6268;
        }
    </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>
</head>
<body>

    <header>
        <h1>🧾 Detalle de Compras Encontradas</h1>
        <p>A continuación se muestran los boletos asociados al correo electrónico que ingresaste:
            <strong style="color: #ffcc80;">
                <% 
                    
                %>
            </strong>
        </p>
    </header>

    <div class="container">
        
        <a href="consultar_boletos.jsp" class="back-link">← Realizar Nueva Consulta</a>

        <h2>Boletos Comprados</h2>
        
        <% 
          
            
            
            ArrayList<Integer> idCompra = new ArrayList<Integer>();
            ArrayList<String> nombreBoleto = new ArrayList<String>();
            ArrayList<Integer> cantidad = new ArrayList<Integer>();
            ArrayList<Double> monto = new ArrayList<Double>();
            ArrayList<String> fecha = new ArrayList<String>();
            ArrayList<String> metodo_pago = new ArrayList<String>();
            
            Conexion con;
            Connection c;
            Statement stmt;
            ResultSet rs;
            ResultSet r;
            
            con = new Conexion();
            con.setCon();
            c = con.getCon();
            stmt = c.createStatement();

            
            r = stmt.executeQuery("select c.*, b.tipo_boleto, b.precio_base, m.nombre_metodo from compra_boleto c inner join boleto b on c.boleto_id=b.boleto_id"
                    + " inner join Metodo_Pago m on c.metodo_id=m.metodo_id where c.cliente_id="+request.getAttribute("id"));
            
            int k=0;
            
            while (r.next()) {
                idCompra.add(r.getInt("compra_id"));
                nombreBoleto.add(r.getString("tipo_boleto"));
                cantidad.add(r.getInt("nm_boletos"));
                monto.add(r.getDouble("Monto_Pagado"));
                fecha.add(String.valueOf(r.getDate("fecha_compra")));
                metodo_pago.add(r.getString("nombre_metodo"));
                k=k+1;
             }
            
             for(int i=0; i<k; i++){
            

        %>

        <div class="boleto-card">
            
            <div class="boleto-info">
                <h3><%= nombreBoleto.get(i) %></h3>
                <p><strong>Metodo de Pago:</strong> <%= metodo_pago.get(i) %></p>
                <p><strong>Cantidad:</strong> <%= cantidad.get(i) %></p>
                <p><strong>Monto Pagado:</strong> $<%= String.format("%.2f", monto.get(i)) %></p>
                <p><strong>Fecha de Compra:</strong> <%= fecha.get(i) %></p>
            </div>
            
            <div class="boleto-actions">
                
                <form action="EdicionBoleto" method="POST">
                    <input type="hidden" name="id_boleto" value="<%= idCompra.get(i) %>">
                    <button type="submit" class="btn btn-edit">Editar</button>
                </form>
                
                <form action="EliminacionBoleto" method="POST" onsubmit="return confirmarEliminar(event)">
                    <input type="hidden" name="id_boleto" value="<%= idCompra.get(i) %>">
                    <input type="hidden" name="monto_monto" value="<%= monto.get(i) %>">
                    <input type="hidden" name="id_cliente" value="<%= request.getAttribute("id") %>">
                    <button type="submit" class="btn btn-delete">Eliminar</button>
                </form>
                
            </div>
        </div>
        <%
            }
        %>         

    </div>
    
    <script>
        function confirmarEliminar(event) {
            // Previene el envío inmediato del formulario
            event.preventDefault(); 
            
            Swal.fire({
                title: '¿Estás seguro?',
                text: "Esta acción eliminará la compra de tu boleto de forma permanente.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Si el usuario confirma, envía el formulario
                    event.target.submit();
                }
            });
            return false;
        }

        // Lógica de SweetAlert para mensajes de éxito/error (del Servlet de acción)
        window.onload = function() {
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
