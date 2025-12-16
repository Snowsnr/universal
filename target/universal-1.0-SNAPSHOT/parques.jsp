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
    <title>Parques, Atracciones y Eventos - Universal</title>
    
    <style>
        /* Estilos Generales */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #ffffff; /* FONDO BLANCO */
            color: #333; /* Texto oscuro */
            line-height: 1.6;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Encabezado */
        header {
            background-color: #1abc9c;
            padding: 25px 20px;
            text-align: center;
            border-bottom: 5px solid #f39c12; /* Naranja/Oro */
            margin-bottom: 30px;
        }
        header h1 {
            margin: 0;
            font-size: 2.5em;
            color: white;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
        }
        header p {
            color: #eee;
        }
        
        /* Sección de Parques */
        .park-section {
            background-color: #f8f9fa; /* Fondo muy claro (casi blanco) para la sección */
            border: 1px solid #ddd; /* Borde sutil */
            border-radius: 10px;
            margin-bottom: 30px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .park-title {
            color: #1abc9c;
            border-bottom: 3px solid #1abc9c;
            padding-bottom: 10px;
            margin-top: 0;
            display: flex;
            justify-content: space-between;
            align-items: baseline;
        }
        .park-title span {
            font-size: 0.6em;
            color: #666; /* Texto oscuro sutil */
            font-weight: normal;
        }
        
        /* Subsecciones (Atracciones/Eventos) */
        .subsection {
            margin-top: 20px;
            padding: 15px;
            background-color: #e9ecef; /* Fondo claro para subsecciones */
            border-radius: 8px;
        }
        .subsection h4 {
            color: #007bff; /* Título azul */
            border-bottom: 1px dashed #adb5bd;
            padding-bottom: 5px;
        }
        .list-items {
            list-style-type: none;
            padding: 0;
            color: #333; /* Texto de la lista oscuro */
        }
        .list-items li {
            padding: 10px 0;
            border-bottom: 1px solid #ced4da;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.95em;
        }
        .list-items li:last-child {
            border-bottom: none;
        }
        
        /* Detalles (Badges) */
        .details-badge {
            background-color: #6c757d;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.8em;
            color: white;
            white-space: nowrap;
        }
        .details-badge strong {
            color: #ffc107;
        }

        /* Botón de regreso */
        .back-link {
            display: inline-block;
            background-color: #f39c12;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
            margin-bottom: 40px;
            transition: background-color 0.3s;
        }
        .back-link:hover {
            background-color: #e67e22;
        }
    </style>
</head>
<body>

    <header>
        <h1>Explora Nuestros Parques Temáticos</h1>
        <p>Atracciones, Eventos y Horarios</p>
    </header>

    <div class="container">
        <a href="index.jsp" class="back-link">← Volver a la Página Principal</a>
        
        <%            
            Conexion con;
            Connection c;
            Statement stmt;
            ResultSet rs;
            ResultSet r;

            int neid;
            int i = 0;

        %>
        <%            con = new Conexion();
            con.setCon();
            c = con.getCon();
            stmt = c.createStatement();

            
            r = stmt.executeQuery("Select * From parque");
            int k = 0;
            
            ArrayList<String> nombreatraccion = new ArrayList<String>();
            ArrayList<String> tipo = new ArrayList<String>();
            ArrayList<String> altura = new ArrayList<String>();
            ArrayList<String> fila = new ArrayList<String>();
            
            String[] nombre = new String[5];
            String[] ubicacion = new String[5];

            while (r.next()) {

                nombre[k] = r.getString("nombre_parque");
                ubicacion[k]= r.getString("ubicacion");
                k=k+1;
             }
            
            r = stmt.executeQuery("Select * From atraccion where parque_id=1");
            int k2=0;
            
            while (r.next()) {
                nombreatraccion.add(r.getString("nombre"));
                tipo.add(r.getString("Descripcion"));
                altura.add(String.valueOf(r.getInt("restriccion_altura")));
                fila.add(String.valueOf(r.getTime("tiempo_fila_promedio")));
                k2=k2+1;
             }
            
            r = stmt.executeQuery("Select * From atraccion where parque_id=2");
            int k3=k2;
            
            while (r.next()) {
                nombreatraccion.add(r.getString("nombre"));
                tipo.add(r.getString("Descripcion"));
                altura.add(String.valueOf(r.getInt("restriccion_altura")));
                fila.add(String.valueOf(r.getTime("tiempo_fila_promedio")));
                k3=k3+1;
             }
            
            r = stmt.executeQuery("Select * From atraccion where parque_id=3");
            int k4=k3;
            
            while (r.next()) {
                nombreatraccion.add(r.getString("nombre"));
                tipo.add(r.getString("Descripcion"));
                altura.add(String.valueOf(r.getInt("restriccion_altura")));
                fila.add(String.valueOf(r.getTime("tiempo_fila_promedio")));
                k4=k4+1;
             }
            
            r = stmt.executeQuery("Select * From atraccion where parque_id=4");
            int k5=k4;
            
            while (r.next()) {
                nombreatraccion.add(r.getString("nombre"));
                tipo.add(r.getString("Descripcion"));
                altura.add(String.valueOf(r.getInt("restriccion_altura")));
                fila.add(String.valueOf(r.getTime("tiempo_fila_promedio")));
                k5=k5+1;
             }
            
            r = stmt.executeQuery("Select * From atraccion where parque_id=5");
            int k6=k5;
            
            while (r.next()) {
                nombreatraccion.add(r.getString("nombre"));
                tipo.add(r.getString("Descripcion"));
                altura.add(String.valueOf(r.getInt("restriccion_altura")));
                fila.add(String.valueOf(r.getTime("tiempo_fila_promedio")));
                k6=k6+1;
             }
           
            ArrayList<String> nombreevento = new ArrayList<String>();
            ArrayList<String> tipoevento = new ArrayList<String>();
            
            r = stmt.executeQuery("Select * From evento where parque_id=1");
            int e=0;
            
            while (r.next()) {
                nombreevento.add(r.getString("nombre"));
                tipoevento.add(r.getString("Descripcion_evento"));
                e=e+1;
             }
            
            r = stmt.executeQuery("Select * From evento where parque_id=2");
            int e1=e;
            
            while (r.next()) {
                nombreevento.add(r.getString("nombre"));
                tipoevento.add(r.getString("Descripcion_evento"));
                e1=e1+1;
             }
            
            r = stmt.executeQuery("Select * From evento where parque_id=3");
            int e2=e1;
            
            while (r.next()) {
                nombreevento.add(r.getString("nombre"));
                tipoevento.add(r.getString("Descripcion_evento"));
                e2=e2+1;
             }
            
            r = stmt.executeQuery("Select * From evento where parque_id=4");
            int e3=e2;
            
            while (r.next()) {
                nombreevento.add(r.getString("nombre"));
                tipoevento.add(r.getString("Descripcion_evento"));
                e3=e3+1;
             }
            
            r = stmt.executeQuery("Select * From evento where parque_id=5");
            int e4=e3;
            
            while (r.next()) {
                nombreevento.add(r.getString("nombre"));
                tipoevento.add(r.getString("Descripcion_evento"));
                e4=e4+1;
             }
            
            int[] ks = {0, k2, k3, k4, k5, k6};
            int[] es = {0, e, e1, e2, e3, e4};
         
            
            for(int j=0; j<k; j++){
        %>
        <section class="park-section">
            
            <h2 class="park-title">
                <%=nombre[j]%>
                
                <span>Ubicación: <%=ubicacion[j]%></span>
            </h2>
            
            <div class="subsection">
                <h4>Atracciones Principales 🎢</h4>
                <ul class="list-items">
                <%
                for(int s=ks[j]; s<ks[j+1]; s++){
                %>
                <li>
                        <span>
                            <%=nombreatraccion.get(s)%> 
                            <small style="color:#666;">(<%=tipo.get(s)%>)</small>
                        </span>
                        
                        <span class="details-badge">
                            Altura Mín.: <strong><%=altura.get(s)%> cm</strong> | 
                            Fila Est.: <strong><%=fila.get(s)%></strong>
                        </span>
                    </li>
                <%
                    }
                %>
                
            </ul>
            <div class="subsection">
                <h4>Eventos y Shows Destacados 🎭</h4>
                <ul class="list-items">
                <%
                for(int s=es[j]; s<es[j+1]; s++){
                %>
                <li>
                        <span>
                            <%=nombreevento.get(s)%> 
                            
                        </span>
                        
                    <span class="details-badge" >
                            <%=tipoevento.get(s)%>
                        </span>
                    </li>
                <%
                    }
                %>
                
            </ul>
        </div>
            
        </section>
        <%
            }
        %>

    </div>
</body>
</html>