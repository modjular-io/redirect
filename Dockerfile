FROM nginx:alpine

LABEL maintainer "Jeffrey Phillips Freeman <the@jeffreyfreeman.me>"

ADD run.sh /run.sh
ADD redirect.template /etc/nginx/redirect.template
ADD proxy.template /etc/nginx/proxy.template

RUN chmod +x /run.sh

CMD ["/run.sh"]

ENV VIRTUAL_PORT 80

