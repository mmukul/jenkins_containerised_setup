
############################################################
# Dockerfile to build Jenkins container images
# Based on CentOS
############################################################


# Set the base image to CentOS
FROM centos:centos7

# Execute commands with 'root' user
USER root

# Create jenkins directory
RUN mkdir -p /usr/share/jenkins/ref

# Install required packages
RUN yum install -y java-1.8.0-openjdk epel-release wget
RUN wget --no-verbose -O /usr/share/jenkins/ref/jenkins.war http://mirrors.jenkins.io/war-stable/latest/jenkins.war
	
VOLUME ["/run", "/tmp", "/var/jenkins_home"]
	
USER jenkins 

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/jre-1.8.0-openjdk"
ENV JRE_HOME="/usr/lib/jvm/jre"
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log"
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Expose port 8080
EXPOSE 8080
EXPOSE 50000

USER root

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY install-plugins.sh /usr/share/jenkins/ref/install-plugins.sh

RUN chmod 755 /usr/share/jenkins/ref/install-plugins.sh
RUN /usr/share/jenkins/ref/install-plugins.sh blueocean-git-pipeline cobertura findbugs junit

CMD ["java", "-jar", "/usr/share/jenkins/ref/jenkins.war"]