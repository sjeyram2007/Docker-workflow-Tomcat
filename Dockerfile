# Use a minimal base image
FROM ubuntu:20.04

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y wget \
  && apt-get install unzip \
  && apt-get install -y gpg \
  && rm -rf /var/lib/apt/lists/*

# Set the Tomcat version
ENV TOMCAT_VERSION="9.0.100"

# Install dependencies
RUN wget -O - https://apt.corretto.aws/corretto.key |  gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" |  tee /etc/apt/sources.list.d/corretto.list


RUN apt-get update \
    && apt-get install -y java-1.8.0-amazon-corretto-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and extract Tomcat
RUN wget -O /tmp/tomcat.tar.gz https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar xf /tmp/tomcat.tar.gz -C /opt && \
    rm /tmp/tomcat.tar.gz && \
    mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# Set environment variables
ENV CATALINA_HOME="/opt/tomcat"
ENV PATH="$CATALINA_HOME/bin:$PATH"

# Download and extract workflow
RUN wget -O /tmp/fcwebworkflow_war.zip https://filecatalyst.software/public/filecatalyst/Workflow/5.1.7.242/fcwebworkflow_war.zip && \
    unzip /tmp/fcwebworkflow_war.zip && \
    cp fcwebworkflow_war/workflow.war /opt/tomcat/webapps && \
    rm -rf /tmp/fcweb/*


# Expose Tomcat port
EXPOSE 10090
#RUN apt-get purge -y openjdk-11-jdk wget && \
#    apt-get autoremove -y && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* /opt/tomcat/webapps/*

# Start Tomcat
CMD ["catalina.sh", "run"]


