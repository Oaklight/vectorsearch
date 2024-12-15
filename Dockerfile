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

# Copy pg_search .deb package from the host system
COPY pg_search.deb /tmp/pg_search.deb
RUN dpkg -i /tmp/pg_search.deb || apt-get install -fy && \
    rm /tmp/pg_search.deb

######################
# pgvectorscale
######################

# Copy pgvectorscale .deb package from the host system
COPY pgvectorscale.deb /tmp/pgvectorscale.deb
RUN dpkg -i /tmp/pgvectorscale.deb || apt-get install -fy && \
    rm /tmp/pgvectorscale.deb

######################
# Cleanup
######################

# Clean up the .deb package and APT cache
RUN apt-get autoremove --purge -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# The postgresql.conf.sample file serves as a template for postgresql.conf, which is created upon the first container start.
# Our settings are added to postgresql.conf.sample to ensure they are applied to postgresql.conf.
# The `postgres` database is the default database in every Postgres installation.
RUN sed -i "s/^#shared_preload_libraries = ''/shared_preload_libraries = 'pg_search'/" /usr/share/postgresql/postgresql.conf.sample

# No need for an ENTRYPOINT or CMD if the base image handles PostgreSQL startup
COPY ./bootstrap.sh /docker-entrypoint-initdb.d/10_bootstrap_paradedb.sh