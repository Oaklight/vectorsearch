# VectorSearch Docker Image Build Guide

This project provides a Dockerfile to build a custom PostgreSQL-based image with extensions for vector search. You can customize the build by adjusting the variables in the `Makefile`.

## Build Instructions

1. Clone the repository:

```bash
git clone <repository_url>
cd codecad-rag/retrieval/docker
```

2. To build the Docker image with the default settings:

```bash
make build
```

3. To customize the build, you can modify the following variables in the `Makefile`:

   - **BUILD_VERSION**: The version of the build. Default is `0.3`.
   - **PG_VERSIONS**: The major versions of PostgreSQL to build for. Default is `14 15 16 17`.
   - **PGVECTOR_BASE_VERSION**: The base version of the `pgvector` extension. Default is `0.8.0`.
   - **PG_SEARCH_VERSION**: The version of the `pg_search` extension. Default is `0.15.8`.
   - **PG_VECTORSCALE_VERSION**: The version of the `pgvectorscale` extension. Default is `0.5.1`.

   For example, to build with PostgreSQL 15 and a custom build version:

```bash
# Edit the Makefile and set:
BUILD_VERSION = 1.0
```

4. After modifying the `Makefile`, you can build the Docker image with:

```bash
make build
```

5. To clean up the downloaded `.deb` files:

```bash
make clean
```

6. To prune the Docker images built by this project:

```bash
make prune
```

7. To push the built images to Docker Hub:

```bash
make push
```

## Makefile Variables

The following variables in the `Makefile` can be tuned to adjust the build process:

- **BUILD_VERSION**: The version number to tag the Docker image. Default is `0.3`.
- **PG_SEARCH_VERSION**: The version of the `pg_search` extension to download and install. Default is `0.15.8`.
- **PG_VECTORSCALE_VERSION**: The version of the `pgvectorscale` extension to download and install. Default is `0.5.1`.
- **PG_VERSIONS**: The major versions of PostgreSQL to build for. Default is `14 15 16 17`.
- **PG_VECTOR_BASE_VERSION**: Combines the `PGVECTOR_BASE_VERSION` and PostgreSQL version to form the base image tag.
- **BUILD_TAG**: The tag used for the Docker image based on the build version and PostgreSQL version.
- **LATEST_TAG**: The "latest" tag used for the Docker image based on the PostgreSQL version.

By adjusting these variables, you can customize the Docker image to use different versions of PostgreSQL or the extensions.

For a detailed history of changes, see the [CHANGELOG](CHANGELOG.md).
