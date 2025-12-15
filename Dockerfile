# Usamos una imagen oficial de Tomcat con Java 17 (ajusta la versión si usas otra)
FROM tomcat:9.0-jdk17

# Borramos las aplicaciones por defecto de Tomcat para limpiar
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiamos tu archivo WAR compilado a la carpeta de apps de Tomcat
# Y lo renombramos a ROOT.war para que cargue en la raíz del dominio
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Exponemos el puerto 8080 (el puerto por defecto de Tomcat)
EXPOSE 8080

# El comando de inicio ya lo trae la imagen de Tomcat por defecto, no hace falta ponerlo