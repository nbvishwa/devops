FROM nginx:latest
COPY website /usr/share/nginx/html/
COPY apps.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
