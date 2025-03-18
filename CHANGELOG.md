# Changelog

## [v0.3] - 2025-03-18

- Updated BUILD_VERSION to 0.3
- Updated PG_SEARCH_VERSION to 0.15.8
- Replaced PG_MAJOR_VERSION with PG_VERSIONS to support multiple PostgreSQL versions (14, 15, 16, 17)
- Added 'push' target to push built images to Docker Hub
- Improved download process for pgvectorscale extension

## [v0.2] - 2025-01-18

- Enhanced README with detailed build guide and Docker Compose config
- Fixed makefile prune action
- Added comprehensive .gitignore rules for Docker cleanup
- Refactored Docker build with versioning and cleanup

## [v0.1] - 2024-12-18

- Initial project setup with customized PostgreSQL-based vector database
- Created Dockerfile with PostgreSQL 17 base
- Added basic Makefile for build automation
- Set up initial documentation in README.md
