FROM ghcr.io/uceap/devcontainer-db:v1.0.0 AS importer

# drupal devcontainers should set these to match
ENV MYSQL_ROOT_PASSWORD="secret"
ENV MYSQL_DATABASE="drupal"
ENV MYSQL_USER="drupal"
ENV MYSQL_PASSWORD="password"

# these are just for building
ENV TERMINUS_SITE="uceap-example"
ENV TERMINUS_ENV="dev"

ENV DEBIAN_FRONTEND=noninteractive

# Download the database dump
RUN --mount=type=secret,id=TERMINUS_TOKEN,env=TERMINUS_TOKEN \
    terminus auth:login --machine-token=$TERMINUS_TOKEN \
    && terminus backup:get --element=db --to=/docker-entrypoint-initdb.d/database.sql.gz

# Some of the following is inspired by https://github.com/ispyb/ispyb-docker-pydb

# Entrypoint script does the DB initialization but also runs mysql daemon, but we only want it to initialize the DB
RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]

# Need to change the datadir to something else that /var/lib/mysql because the parent docker file defines it as a volume.
# https://docs.docker.com/engine/reference/builder/#volume :
#       Changing the volume from within the Dockerfile: If any build steps change the data within the volume after
#       it has been declared, those changes will be discarded.
# Also run an empty
RUN ["/usr/local/bin/docker-entrypoint.sh", "mariadbd", "--datadir", "/initialized-db", "--aria-log-dir-path", "/initialized-db"]

RUN rm /docker-entrypoint-initdb.d/*

FROM ghcr.io/uceap/devcontainer-db:v1.0.0

COPY --from=importer /initialized-db /var/lib/mysql
