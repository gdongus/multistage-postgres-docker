# STAGE 1 -  Initialize the database 
FROM postgres:15-alpine AS buildtime_init_builder
ENV POSTGRES_PASSWORD=secret
COPY 1-psql_dump.sql /docker-entrypoint-initdb.d/
RUN echo "exit 0" > /docker-entrypoint-initdb.d/100-exit_before_boot.sh
ENV PGDATA=/pgdata
RUN docker-entrypoint.sh postgres

# STAGE 3 - Copy the initialized db to a new image to reduce size.
FROM postgres:15-alpine AS postgres_runtime
ENV PGDATA=/pgdata
ENV POSTGRES_PASSWORD=secret
COPY --chown=postgres:postgres --from=buildtime_init_builder /pgdata /pgdata
EXPOSE 5432
