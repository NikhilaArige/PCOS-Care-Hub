FROM tomcat:9-jdk11

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Create ROOT directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# Copy all application files
COPY . /usr/local/tomcat/webapps/ROOT/

# Install Oracle JDBC driver
RUN apt-get update && apt-get install -y wget && \
    wget https://download.oracle.com/otn-pub/otn_software/jdbc/1918/ojdbc8.jar -O /usr/local/tomcat/lib/ojdbc8.jar

EXPOSE 8080

CMD ["catalina.sh", "run"]
