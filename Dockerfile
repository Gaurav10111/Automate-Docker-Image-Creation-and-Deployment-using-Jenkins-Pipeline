FROM ubuntu:20.04

RUN apt update && apt install -y nginx curl

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

