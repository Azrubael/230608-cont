# syntax=docker/dockerfile:1
FROM amazonlinux

# RUN yum -y update
# RUN yum -y install httpd
# RUN yum -y install php
# You should replace this file (located at /var/www/html/index.html) 

RUN yum -y update && yum -y install httpd php && yum clean all

COPY ./hello.php /var/www/html/index.php

CMD ["/usr/sbin/httpd","-D","FOREGROUND"]

EXPOSE 80
