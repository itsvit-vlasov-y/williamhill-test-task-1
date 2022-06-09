#    ┬┬ ┐o┌─┐┬─┐
#  ┌ ││ │││  ├─ 
#  └─┘┘─┘┘└─┘┴─┘

FROM nginx:1.22.0-alpine
ENTRYPOINT [ "/entrypoint.sh" ]
COPY entrypoint.sh /entrypoint.sh
COPY index.html /usr/share/nginx/html/index.html
RUN chmod 0755 /entrypoint.sh
