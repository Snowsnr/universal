<%@page import="Clases.Conexion"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Universal Resorts - Reservas</title>
        
        <style>
            /* --- ESTILOS GENERALES --- */
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 20px; background-color: #f0f2f5; color: #333; }
            header { background: linear-gradient(135deg, #007bff, #0056b3); color: white; padding: 30px 20px; text-align: center; border-radius: 12px; margin-bottom: 30px; box-shadow: 0 10px 20px rgba(0, 123, 255, 0.2); }
            .container { max-width: 1200px; margin: auto; }
            
            /* --- BARRA DE HERRAMIENTAS (BUSCADOR + FILTROS) --- */
            .toolbar {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                align-items: center;
                gap: 15px;
                margin-bottom: 30px;
                background: white;
                padding: 15px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            /* Botones de Filtro (NUEVO) */
            .filter-group { display: flex; gap: 10px; }
            
            .btn-filter {
                padding: 10px 20px;
                border: 1px solid #ddd;
                background-color: #f8f9fa;
                color: #555;
                border-radius: 30px; /* Redondos */
                cursor: pointer;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.2s;
                font-size: 0.9em;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .btn-filter:hover { background-color: #e2e6ea; transform: translateY(-2px); }
            
            /* Estilo para el botón activo (seleccionado) */
            .btn-filter.active {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
                box-shadow: 0 4px 10px rgba(0, 123, 255, 0.3);
            }

            /* Buscador */
            .search-form { display: flex; gap: 10px; }
            .input-search { padding: 10px 15px; border-radius: 20px; border: 1px solid #ddd; width: 250px; outline: none; }
            .input-search:focus { border-color: #007bff; }
            .btn-search { padding: 10px 20px; background-color: #333; color: white; border: none; border-radius: 20px; cursor: pointer; font-weight: bold; }
            .btn-search:hover { background-color: #555; }

            /* --- GRID DE TARJETAS --- */
            .results-section { padding: 0; }
            ul.hotel-list { list-style-type: none; padding: 0; margin: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 30px; }
            
            .hotel-card { 
                background: #ffffff; border: 1px solid #ced4da; border-radius: 16px; padding: 25px; 
                display: flex; flex-direction: column; justify-content: space-between; 
                box-shadow: 0 4px 8px rgba(0,0,0,0.05); transition: all 0.3s ease; cursor: pointer; height: 100%; 
            }
            .hotel-card:hover { transform: translateY(-8px); box-shadow: 0 12px 24px rgba(0,0,0,0.15); border-color: #007bff; }

            .hotel-name { font-size: 1.4em; font-weight: 800; color: #1a1a1a; margin-bottom: 10px; display: block; line-height: 1.2; }
            .badge-category { font-size: 0.75em; text-transform: uppercase; padding: 4px 10px; border-radius: 6px; background-color: #f8f9fa; color: #555; border: 1px solid #e9ecef; font-weight: bold; letter-spacing: 0.5px; }
            .badge-express { font-size: 0.85em; background-color: #e6f4ea; color: #1e7e34; padding: 6px 12px; border-radius: 30px; font-weight: 700; display: inline-block; margin-top: 12px; }
            .badge-no-express { font-size: 0.85em; color: #666; background-color: #f1f3f5; padding: 6px 12px; border-radius: 30px; margin-top: 12px; display: inline-block; }

            .price-container { text-align: right; border-top: 2px solid #f1f3f5; padding-top: 15px; }
            .price-amount { font-size: 1.8em; color: #007bff; font-weight: 800; }

            /* --- MODAL --- */
            .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.6); backdrop-filter: blur(5px); align-items: center; justify-content: center; }
            .modal-content { background-color: #fefefe; padding: 0; border-radius: 12px; width: 90%; max-width: 450px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 20px 40px rgba(0,0,0,0.3); animation: zoomIn 0.2s ease-out; margin: 0; }
            @keyframes zoomIn { from {transform: scale(0.9); opacity: 0;} to {transform: scale(1); opacity: 1;} }
            .modal-header { padding: 15px 20px; background: #007bff; color: white; border-top-left-radius: 12px; border-top-right-radius: 12px; display: flex; justify-content: space-between; align-items: center; flex-shrink: 0; }
            .modal-body { padding: 25px; font-size: 1.1em; line-height: 1.6; overflow-y: auto; }
            .modal-footer { padding: 15px 20px; border-top: 1px solid #eee; display: flex; gap: 10px; justify-content: flex-end; background: #f8f9fa; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px; flex-shrink: 0; }
            .close { color: white; font-size: 28px; font-weight: bold; cursor: pointer; transition: color 0.2s; }
            .close:hover { color: #d1e7ff; }
            .btn-modal { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; text-decoration: none; display: inline-block; text-align: center; font-size: 0.95em;}
            .btn-boleto { background-color: #6c757d; color: white; }
            .btn-paquete { background-color: #28a745; color: white; }
        </style>
    </head>
    <body>

        <header>
            <h1>Universal Orlando Resort</h1>
            <p style="font-size: 1.1em; opacity: 0.9;">Catálogo Oficial de Hoteles y Paquetes</p>
        </header>

        <div class="container">
            
            <div class="toolbar">
                <div class="filter-group">
                    <%
                        // Capturamos el filtro actual para saber cuál botón "pintar" de azul
                        String filtroActual = request.getParameter("filtro");
                        if (filtroActual == null) filtroActual = "todos";
                    %>
                    
                    <a href="hospedajes.jsp?filtro=todos" class="btn-filter <%= filtroActual.equals("todos") ? "active" : "" %>">
                        Todos
                    </a>
                    <a href="hospedajes.jsp?filtro=premium" class="btn-filter <%= filtroActual.equals("premium") ? "active" : "" %>">
                        💎 Premium (Express)
                    </a>
                    <a href="hospedajes.jsp?filtro=economico" class="btn-filter <%= filtroActual.equals("economico") ? "active" : "" %>">
                        🎒 Económicos
                    </a>
                </div>

                <form action="hospedajes.jsp" method="GET" class="search-form">
                    <input type="hidden" name="filtro" value="<%= filtroActual %>">
                    <input type="text" name="q" class="input-search" placeholder="Buscar por nombre..." value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
                    <button type="submit" class="btn-search">🔍</button>
                </form>
            </div>

            <div class="results-section">
                <ul class="hotel-list">
                    <%
                        Conexion c;
                        Connection con;
                        c = new Conexion();
                        c.setCon();
                        con = c.getCon();
                        if (con != null) {
                            PreparedStatement ps = null;
                            String sql = "SELECT * FROM Hotel WHERE 1=1 "; // Base para concatenar
                            
                            // 1. LÓGICA DE FILTROS (BOTONES)
                            String filtro = request.getParameter("filtro");
                            
                            if ("premium".equals(filtro)) {
                                // Solo categoría Premier (Express incluido)
                                sql += " AND Categoria_Precio = 'Premier' ";
                            } else if ("economico".equals(filtro)) {
                                // Value y Prime Value
                                sql += " AND (Categoria_Precio LIKE '%Value%') ";
                            }
                            
                            // 2. LÓGICA DE BÚSQUEDA (TEXTO)
                            String busqueda = request.getParameter("q");
                            if (busqueda != null && !busqueda.trim().isEmpty()) {
                                sql += " AND Nombre LIKE ? ";
                            }

                            // Ordenamos por precio
                            sql += " ORDER BY Costo_Base_Noche DESC";

                            ps = con.prepareStatement(sql);
                            
                            // Si usamos el buscador, hay que pasarle el parámetro '?'
                            if (busqueda != null && !busqueda.trim().isEmpty()) {
                                ps.setString(1, "%" + busqueda + "%");
                            }

                            ResultSet rs = ps.executeQuery();
                            boolean hayResultados = false;

                            while (rs.next()) {
                                hayResultados = true;
                                int id = rs.getInt("Hotel_ID");
                                String nombre = rs.getString("Nombre");
                                String categoria = rs.getString("Categoria_Precio"); 
                                double precio = rs.getDouble("Costo_Base_Noche");
                                boolean tieneExpress = rs.getBoolean("Beneficios_Express_Gratis");
                                
                                String textoBeneficio = tieneExpress ? "✨ Incluye Universal Express Unlimited (Valorado en +$120/día)" : "🌟 Entrada Temprana al Parque (1 hora antes de abrir)";
                                String nombreSafe = nombre.replace("'", "\\'");
                    %>

                    <li class="hotel-card" onclick="abrirModal('<%= id %>', '<%= nombreSafe %>', '<%= categoria %>', '<%= precio %>', '<%= textoBeneficio %>')">
                        <div class="hotel-info-top">
                            <span class="hotel-name"><%= nombre %></span>
                            <span class="badge-category"><%= categoria %></span>
                            <br>
                            <% if (tieneExpress) { %>
                                <span class="badge-express">⚡ Express Unlimited Incluido</span>
                            <% } else { %>
                                <span class="badge-no-express">🌟 Early Park Admission</span>
                            <% } %>
                        </div>
                        <div class="price-container">
                            <span style="font-size:0.9em; color:#888;">Precio desde:</span><br>
                            <span class="price-amount">$<%= String.format("%.0f", precio) %></span><br>
                            <span style="font-size:0.8em; color:#888;">USD / noche</span>
                        </div>
                    </li>

                    <% 
                            } 
                            if (!hayResultados) out.println("<p style='grid-column: 1 / -1; text-align: center; color: #666; font-size: 1.2em; padding: 40px;'>No se encontraron hoteles con esos filtros.</p>");
                            con.close(); 
                        } else {
                             out.println("<p style='color:red'>Error de conexión a la base de datos.</p>");
                        }
                    %>
                </ul>
            </div>
        </div>

        <div id="miVentanaModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitulo" style="margin:0; font-size: 1.5em;"></h2>
                    <span class="close" onclick="cerrarModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <div style="display: flex; gap: 15px; margin-bottom: 20px;">
                        <span id="modalCategoria" class="badge-category" style="font-size: 1em; padding: 8px 15px;"></span>
                    </div>
                    <p style="font-size: 1.1em;">Precio Base: <strong style="color: #007bff; font-size: 1.4em;">$<span id="modalPrecio"></span> USD</strong> <span style="font-size:0.8em; color:#666">/ noche</span></p>
                    <div style="background-color: #eef2f7; padding: 20px; border-radius: 10px; margin: 25px 0; border-left: 5px solid #007bff;">
                        <h4 style="margin-top:0; color: #333;">Beneficio Exclusivo:</h4>
                        <p id="modalBeneficio" style="margin-bottom:0; color: #0056b3; font-weight: bold; font-size: 1.1em;">...</p>
                    </div>
                    <p style="font-size: 0.95em; color: #666; line-height: 1.5;">Selecciona una opción para continuar con tu reserva.</p>
                </div>
                <div class="modal-footer">
                    <a id="linkBoleto" href="#" class="btn-modal btn-boleto">🎫 Solo Boletos</a>
                    <a id="linkPaquete" href="#" class="btn-modal btn-paquete">📦 Armar Paquete</a>
                </div>
            </div>
        </div>

        <script>
            function abrirModal(id, nombre, categoria, precio, beneficio) {
                document.getElementById("modalTitulo").innerText = nombre;
                document.getElementById("modalCategoria").innerText = categoria;
                document.getElementById("modalPrecio").innerText = precio;
                document.getElementById("modalBeneficio").innerText = beneficio;
                document.getElementById("linkBoleto").href = "compraBoleto.jsp?hotel_id=" + id + "&nombre=" + encodeURIComponent(nombre);
                document.getElementById("linkPaquete").href = "compraPaquete.jsp?hotel_id=" + id + "&nombre=" + encodeURIComponent(nombre);
                document.getElementById("miVentanaModal").style.display = "flex"; 
            }
            function cerrarModal() { document.getElementById("miVentanaModal").style.display = "none"; }
            window.onclick = function(event) { if (event.target === document.getElementById("miVentanaModal")) { cerrarModal(); } }
        </script>
    </body>
</html>