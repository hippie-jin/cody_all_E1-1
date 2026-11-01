FROM nginx:alpine

LABEL org.opencontainers.image.title="Codyssey Practice Web"
LABEL org.opencontainers.image.description="My first custom web image"

ENV APP_ENV=practice

COPY app/ /usr/share/nginx/html/
