<%-- 
    Document   : compra_paquetes
    Created on : Dec 14, 2025, 8:53:29 PM
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comprar Paquetes Vacacionales - Universal</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>

    <style>
        /* ======================================= */
        /* CSS Original (Estilo General y Boletos) */
        /* ======================================= */
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
        
        /* Modificado para Paquetes (Rojo en lugar de Naranja) */
        header {
            background-color: #e74c3c; 
            padding: 25px 20px;
            text-align: center;
            border-bottom: 5px solid #ffc107; /* Borde amarillo */
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
            color: #e74c3c; /* Rojo temático */
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
        
        /* Destacado del Monto y el Botón */
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
        
        /* Nuevos estilos para la estructura de Paquetes */
        .date-group {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .date-group .form-group {
            flex: 1;
        }

        #checkout_display {
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #eee; /* Fondo ligeramente gris */
            border-radius: 4px;
            font-weight: bold;
            color: #495057;
        }
        
        /* Estilo para la caja de descripción del paquete */
        .description-box {
            background-color: #fff3cd; 
            color: #856404; 
            padding: 15px;
            border-radius: 5px;
            border: 1px solid #ffeeba;
            font-size: 0.9em;
            margin-top: 10px;
        }
        /* Fin de estilos CSS */
    </style>
</head>
<body>
    
    <header>
        <h1>Comprar Paquetes Vacacionales 🎁</h1>
        <p>Selecciona uno de nuestros paquetes todo incluido y tu fecha de llegada.</p>
    </header>

    <div class="container">
        
        <a href="index.jsp" class="back-link">← Volver al Inicio</a>

        <form action="CompraPaquete" method="POST" class="purchase-form">

            <fieldset>
                <legend>1. Detalles del Cliente</legend>
                <div class="form-group"><label for="nombre">Nombre Completo (*)</label><input type="text" id="nombre" name="nombre" required placeholder="Ej: Juan Pérez"></div>
                <div class="form-group"><label for="email">Email (*)</label><input type="email" id="email" name="email" required placeholder="ejemplo@dominio.com"></div>
                <div class="form-group"><label for="telefono">Teléfono</label><input type="tel" id="telefono" name="telefono" placeholder="Ej: 555-123-4567"></div>
            </fieldset>

            <fieldset>
                <legend>2. Configuración y Fechas</legend>
                
                <div class="form-group">
                    <label for="paquete_id">Seleccionar Paquete Vacacional (*)</label>
                    <select id="paquete_id" name="paquete_id" required onchange="calcularMontoEstimado()">
                        <option value="" data-precio="0" data-noches="0" data-desc="Seleccione un paquete para ver sus detalles.">-- SELECCIONA TU PAQUETE TODO INCLUIDO --</option>
                        
                        <option value="1" data-precio="950.00" data-noches="2" data-desc="4 personas, 2 noches en Hotel Value, 4 boletos base de 2 días.">1. Familiar Aventura 3D/2N - $950.00</option>
                        <option value="2" data-precio="2500.00" data-noches="3" data-desc="2 personas, 3 noches en Hotel Premier, Express Pass ilimitado.">2. Romance Express 4D/3N - $2,500.00</option>
                        <option value="3" data-precio="1600.00" data-noches="2" data-desc="3 personas, 2 noches en Hotel Preferred, 3 boletos Park-to-Park de 3 días.">3. Escapada Grupal 3D/2N - $1,600.00</option>
                        <option value="4" data-precio="450.00" data-noches="1" data-desc="1 persona, 1 noche en Hotel Value, 1 boleto base de 2 días.">4. Solo Aventura Base 2D/1N - $450.00</option>
                        <option value="5" data-precio="6900.00" data-noches="5" data-desc="4 personas, 5 noches en suite Hotel Premier, Express Pass y tour VIP.">5. Lujo Extremo VIP 6D/5N - $6,900.00</option>
                        <option value="6" data-precio="1250.00" data-noches="2" data-desc="2 personas, 2 noches en Hotel Preferred, boletos 3 días (incluye Volcano Bay).">6. Volcano Bay & Más 3D/2N - $1,250.00</option>
                        <option value="7" data-precio="3100.00" data-noches="3" data-desc="5 personas, 3 noches en Hotel Preferred, boletos Park-to-Park de 4 días.">7. Familiar Estándar 4D/3N - $3,100.00</option>
                        <option value="8" data-precio="750.00" data-noches="1" data-desc="2 personas, 1 noche en Hotel Value, 2 boletos base de 2 días.">8. Escape Rápido Económico 2D/1N - $750.00</option>
                        <option value="9" data-precio="4800.00" data-noches="4" data-desc="6 personas, 4 noches en Hotel Preferred, boletos Park-to-Park de 5 días.">9. Maxi-Grupo 5D/4N - $4,800.00</option>
                        <option value="10" data-precio="2150.00" data-noches="2" data-desc="2 personas, 2 noches en Hotel Premier, boletos 3 días (acceso total a áreas temáticas).">10. Aventura Wizarding 3D/2N - $2,150.00</option>
                        
                    </select>
                </div>
                
                <div class="description-box">
                    <span style="font-weight: bold;">Detalles del Paquete:</span> <span id="paquete_descripcion">Seleccione un paquete para ver sus detalles.</span>
                </div>

                <div class="date-group" style="margin-top: 25px;">
                    <div class="form-group">
                        <label for="fecha_checkin">Fecha de Check-in (Llegada) (*)</label>
                        <input type="date" id="fecha_checkin" name="fecha_checkin" required onchange="calcularMontoEstimado()">
                    </div>
                    <div class="form-group">
                        <label>Fecha de Check-out (Salida) Estimada</label>
                        <p id="checkout_display">
                            --
                        </p>
                    </div>
                </div>

            </fieldset>

            <fieldset>
                <legend>3. Pago y Monto Fijo</legend>

                <div class="form-group">
                    <label for="metodo_pago">Método de Pago (*)</label>
                    <select id="metodo_pago" name="metodo_pago" required>
                       <option value="">-- Seleccione el método --</option>
                        <option value="Tarjeta VISA">Tarjeta de Crédito / Débito (VISA)</option>
                        <option value="MasterCard/AMEX">MasterCard / AMEX</option>
                        <option value="PayPal">PayPal</option>
                        </select>
                </div>
                
                <div class="form-group">
                    <label>Monto Total Fijo:</label>
                    <p style="font-size: 1.8em; font-weight: bold; color: #e74c3c;">$ <span id="monto_total_display">0.00</span> USD</p>
                    <small>Este es el costo final y fijo por el paquete seleccionado.</small>
                </div>
                
                <input type="hidden" id="monto_pagado_hidden" name="monto_pagado" value="0.00"/>
                <input type="hidden" id="fecha_checkout_hidden" name="fecha_checkout" value=""/>

            </fieldset>

            <button type="submit" class="submit-button">
                Comprar Paquete
            </button>
            
        </form>

    </div>

    <script>
        // Función para formatear una fecha Date a DD/MM/YYYY
        function formatDate(date) {
            let dd = date.getDate();
            let mm = date.getMonth() + 1; // Meses de 0 a 11
            const yyyy = date.getFullYear();

            // Añadir cero inicial si es necesario
            if (dd < 10) dd = '0' + dd;
            if (mm < 10) mm = '0' + mm;

            return dd + '/' + mm + '/' + yyyy;
        }

        // Nueva función para obtener la fecha en formato YYYY-MM-DD (para el campo hidden)
        function formatHiddenDate(date) {
            const yyyy = date.getFullYear();
            let mm = date.getMonth() + 1;
            let dd = date.getDate();

            if (mm < 10) mm = '0' + mm;
            if (dd < 10) dd = '0' + dd;

            return yyyy + '-' + mm + '-' + dd;
        }


        function calcularMontoEstimado() {
            // 1. Obtener elementos
            const selectPaquete = document.getElementById('paquete_id');
            const inputCheckin = document.getElementById('fecha_checkin');
            
            const displayMonto = document.getElementById('monto_total_display');
            const hiddenMonto = document.getElementById('monto_pagado_hidden');
            const displayCheckout = document.getElementById('checkout_display');
            const hiddenCheckout = document.getElementById('fecha_checkout_hidden');
            const displayDesc = document.getElementById('paquete_descripcion');

            // 2. Obtener la opción seleccionada
            const selectedOption = selectPaquete.options[selectPaquete.selectedIndex];
            
            // 3. Obtener datos de atributos
            const precioBase = parseFloat(selectedOption.getAttribute('data-precio') || 0);
            const numNoches = parseInt(selectedOption.getAttribute('data-noches') || 0);
            const descripcion = selectedOption.getAttribute('data-desc') || 'Seleccione un paquete para ver sus detalles.';

            // 4. CÁLCULO DE FECHA DE CHECKOUT (Lógica corregida)
            if (inputCheckin.value && numNoches > 0) {
                
                // Convertir la fecha de Check-in, asegurando que la interprete correctamente.
                // Si la fecha es 'YYYY-MM-DD', la creamos a mediodía para evitar problemas de UTC/zona horaria.
                const checkinDate = new Date(inputCheckin.value + 'T12:00:00');
                
                // Calcular los milisegundos para el número de noches (días)
                const msPorDia = 24 * 60 * 60 * 1000;
                const msNoches = numNoches * msPorDia;
                
                // Sumar los milisegundos para obtener la fecha de Checkout
                const checkoutTimestamp = checkinDate.getTime() + msNoches;
                const checkoutDate = new Date(checkoutTimestamp);
                
                // Formatear para visualización (DD/MM/YYYY)
                const checkoutStrDisplay = formatDate(checkoutDate);
                // Formatear para el envío al servidor (YYYY-MM-DD)
                const checkoutStrHidden = formatHiddenDate(checkoutDate);
                
                displayCheckout.textContent = checkoutStrDisplay;
                hiddenCheckout.value = checkoutStrHidden; // ¡Guardar en el hidden en formato estándar!

            } else {
                displayCheckout.textContent = "Ingrese Check-in";
                hiddenCheckout.value = "";
            }

            // 5. CÁLCULO DE MONTO (Fijo)
            const montoTotal = precioBase;

            // 6. Actualizar la descripción
            displayDesc.textContent = descripcion;

            // 7. Actualizar la visualización y el campo oculto
            const montoFormateado = montoTotal.toFixed(2);
            
            displayMonto.textContent = montoFormateado;
            hiddenMonto.value = montoFormateado;
        }

        // Inicializar la visualización y adjuntar el manejador de notificaciones
        window.onload = function() {
            calcularMontoEstimado();
            
            // Lógica de notificación SweetAlert2
            <% if (request.getAttribute("mensaje") != null) { %>      
                Swal.fire({
                    icon: "success",
                    title: "<%=request.getAttribute("mensaje")%>",
                    showConfirmButton: false,
                    timer: 5000
                });      
            <% } %>
        };
    </script>

</body>
</html>