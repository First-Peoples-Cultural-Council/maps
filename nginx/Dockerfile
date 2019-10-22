FROM nginx:1.15-alpine

COPY conf.d/default.conf.template /etc/nginx/conf.d/default.conf.template

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD /usr/sbin/nginx -g 'daemon off;'

