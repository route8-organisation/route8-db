FROM postgres:16

ENV POSTGRES_USER=route8-user
ENV POSTGRES_PASSWORD=123
ENV POSTGRES_DB=route8

COPY init-db.sql /docker-entrypoint-initdb.d/init-db.sql

COPY server.key /var/lib/postgresql/server.key
COPY server.crt /var/lib/postgresql/server.crt

RUN chmod 600 /var/lib/postgresql/server.key
RUN chown postgres:postgres /var/lib/postgresql/server.key

ENTRYPOINT ["docker-entrypoint.sh"]]
CMD ["-c", "ssl=on", \
    "-c", "ssl_cert_file=/var/lib/postgresql/server.crt", \
    "-c", "ssl_key_file=/var/lib/postgresql/server.key"]
