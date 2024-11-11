FROM nginx

WORKDIR /home/
COPY ./mini_server.c .
COPY ./run.sh .
COPY ./nginx.conf /etc/nginx/nginx.conf
RUN apt-get update && apt-get install -y gcc spawn-fcgi libfcgi-dev

ENTRYPOINT ["bash", "./run.sh"]