FROM alpine:3.20

WORKDIR /app

COPY hello.c start.sh .
COPY nginx/nginx.conf /etc/nginx/nginx.conf

RUN apk update \
    && apk add --no-cache \
        nginx \
        spawn-fcgi \
        gcc \
        musl-dev \
        fcgi-dev \
	fcgi \
    && chown -R nginx:nginx /var/log/nginx /run/nginx /etc/nginx \
    && gcc -o hello.fcgi hello.c -lfcgi \
    && apk del gcc musl-dev fcgi-dev \
    && rm -f hello.c && rm -rf /var/cache/apk/* \
    && chmod +x /app/start.sh 
HEALTHCHECK --interval=30s --timeout=3s CMD wget -q --spider http://localhost:81/ || exit 1
USER nginx
EXPOSE 81
ENTRYPOINT ["/app/start.sh"]
