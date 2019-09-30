ARG  ALPINE_VERSION="${ALPINE_VERSION:-3.10}"
FROM alpine:"${ALPINE_VERSION}"

ENV TZ="Asia/Shanghai"
ENV TOMCAT_VERSION="9.0.26"

# Iterate through all locale and install it
# Note that locale -a is not available in alpine linux, use `/usr/glibc-compat/bin/locale -a` instead
COPY locale.md /locale.md
COPY entrypoint.sh /opt/entrypoint.sh

RUN apk update && apk add --no-cache ca-certificates bash openssh tzdata rsync busybox-extras iproute2 && \
    apk --no-cache add openjdk8 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin\ yes/" /etc/ssh/sshd_config && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-i18n-2.30-r0.apk && \
    apk add glibc-2.30-r0.apk glibc-bin-2.30-r0.apk glibc-i18n-2.30-r0.apk && \
    wget http://apache.mirrors.lucidnetworks.net/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    tar zxvf /apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    mv /apache-tomcat-$TOMCAT_VERSION /tomcat && \
    chmod 755 /opt/entrypoint.sh && \
    chmod 4755 /bin/busybox && \
    rm -rf /var/cache/apk/* && \
    rm -rf /glibc-* && \
    rm -rf /apache-tomcat-* && \
    rm -rf /tmp/*

RUN cat /locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8

ENV USER_LOGIN_SHELL="/bin/bash" \
    USER_LOGIN_SHELL_FALLBACK="/bin/ash"

EXPOSE 22 8080

WORKDIR /tomcat

ENTRYPOINT ["/opt/entrypoint.sh"]
