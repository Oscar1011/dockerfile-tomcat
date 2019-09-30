FROM dockerbilltang/openjdk

ENV TOMCAT_VERSION="9.0.26"

COPY entrypoint.sh /opt/entrypoint.sh

RUN wget http://apache.mirrors.lucidnetworks.net/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    tar zxvf /apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    mv /apache-tomcat-$TOMCAT_VERSION /tomcat && \
    rm -rf /apache-tomcat-* && \
    rm -rf /tmp/*

EXPOSE 22 8080

WORKDIR /tomcat

ENTRYPOINT ["/opt/entrypoint.sh"]
