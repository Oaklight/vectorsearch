# Vectorsearch Docker Image

## About

Initially, I targeted the `paradedb/paradedb:0.12.0-pg17` image for my task, but it became clear that we only required its `pg_search` and `pgvector` extensions, with the rest being unnecessary for our use case.

Additionally, an older release of paradedb included `pgvectorscale` from Timescale for its advanced algorithms. However, this was removed in the latest release. I decided to explore using it, which brings us to the current setup.

## Build

I started with the Postgres 17 base image featuring `pgvector` (by time of writing, the latest version is `pgvector/pgvector:0.8.0-pg17` ). 
Subsequently, I added `pg_search` and `pgvectorscale` as dependencies.

The `bootstrap.sh` script includes SQL commands to create these extensions for every potential database, ensuring a comprehensive setup.

## Usage

1. I have published a docker image for vectorsearch at [dockerhub](https://hub.docker.com/r/oaklight/vectorsearch)

2. To build from the Dockerfile: `make build`. For more details regarding the build process, please refer to the [makefile details](./README_makefile.md).

To run the container:

```bash
docker run --name vectorsearch -p <5432>:5432 -v <$pwd/pgdata>:/var/lib/postgresql/data/ -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydatabase oaklight/vectorsearch
```

or use `docker compose` :

```bash
docker compose up -d
```

## Docker Compose Sample Configuration

For easier management of the container, a sample `docker-compose.yaml` is provided as `compose.yaml.sample` . You can use this file as a starting point for configuring and running the service with Docker Compose.

Here is the content of `compose.yaml.sample` :

```yaml
services:
  paradedb:
    image: oaklight/vectorsearch:latest-pg17
    container_name: vectorsearch
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydatabase
    ports:
      - 5432:5432
    volumes:
      - $pwd/pgdata:/var/lib/postgresql/data/
```

### How to Use the Sample Configuration

1. Copy `compose.yaml.sample` to `compose.yaml`:
   

```bash
   cp compose.yaml.sample compose.yaml
   ```

2. Modify `compose.yaml` as needed to match your environment and configuration preferences.

3. Run the following command to start the service using Docker Compose:
   

```bash
   docker compose up -d
   ```

This will start the `vectorsearch` container with the configurations specified in `compose.yaml` .

## Note

The image is based on the official postgres image, so you can use the same commands to interact with the database.

For example, you could use `psql` to connect to the database:

```bash
psql -h <your_container_name> -U <username> -d <database>
```

You can also use `pgAdmin` to connect to the database.
