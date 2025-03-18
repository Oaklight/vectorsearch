# Use the official pgvector image as the base image
ARG PG_VECTOR_BASE_VERSION=0.8.0-pg17

FROM pgvector/pgvector:${PG_VECTOR_BASE_VERSION}

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Switch to root for configuring runtime dependencies
USER root

######################
# pg_search
######################

# Install all .deb packages and cleanup in one RUN command
COPY pg_search.deb pgvectorscale.deb /tmp/
RUN dpkg -i /tmp/pg_search.deb || apt-get install -fy && \
    dpkg -i /tmp/pgvectorscale.deb || apt-get install -fy && \
    apt-get autoremove --purge -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/log/*.log /var/log/apt/* /var/log/dpkg.log

# The postgresql.conf.sample file serves as a template for postgresql.conf, which is created upon the first container start.
# Our settings are added to postgresql.conf.sample to ensure they are applied to postgresql.conf.
# The `postgres` database is the default database in every Postgres installation.
RUN sed -i "/^shared_preload_libraries/s/'\([^']*\)'/'\1,pg_search'/" /usr/share/postgresql/postgresql.conf.sample

# No need for an ENTRYPOINT or CMD if the base image handles PostgreSQL startup
COPY ./bootstrap.sh /docker-entrypoint-initdb.d/10_bootstrap_paradedb.sh
