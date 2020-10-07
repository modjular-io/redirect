FROM nginx:alpine

LABEL maintainer "Jeffrey Phillips Freeman <the@jeffreyfreeman.me>"

ADD run.sh /run.sh
ADD default.conf /etc/nginx/conf.d/default.conf

RUN chmod +x /run.sh

CMD ["/run.sh"]

ENV VIRTUAL_HOST
ENV LETSENCRYPT_HOST
ENV VIRTUAL_PORT 80
ENV LETSENCRYPT_EMAIL jeffrey.freeman@qoto.org

