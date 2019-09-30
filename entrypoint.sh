#!/bin/bash

set -e

# enable debug mode if desired
if [[ "${DEBUG}" == "true" ]]; then
    set -x
fi

lang="${LANG:-zh_CN.UTF-8}"

echo "LANG=$lang" >> /etc/profile
echo "LANGUAGE=$lang" >> /etc/profile
echo "LC_ALL=$lang" >> /etc/profile
source /etc/profile

user=${USER:-root}
password=${PASSWORD:-alpine@}
root_password=${ROOT_PASSWORD}

if [[ "$user" != "root" ]]; then
   if ! id -u $user > /dev/null 2>&1; then
      adduser -u 1000 $user -G root -D
      echo "$user:$password" | chpasswd
   fi
fi

if [ -n "$root_password" ]; then
    echo "root:$root_password" | chpasswd
else
    echo "root:$password" | chpasswd
fi

if [[ "${ENABLE_SSH}" == "true" ]]; then
   exec /usr/sbin/sshd
fi

exec /tomcat/bin/catalina.sh run
