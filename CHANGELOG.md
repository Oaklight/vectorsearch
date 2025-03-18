# Changelog

## [v0.3] - 2025-03-18

### Added

- Added 'push' target to push built images to Docker Hub

### Changed

- Updated BUILD_VERSION to 0.3
- Updated PG_SEARCH_VERSION to 0.15.8
- Replaced PG_MAJOR_VERSION with PG_VERSIONS to support multiple PostgreSQL versions (14, 15, 16, 17)
- Improved download process for pgvectorscale extension
- Changed pg_search extension loading in bootstrap.sh

### Fixed

- Streamlined .deb package installation in Dockerfile
- Removed unnecessary silent echo commands from makefile

## [v0.2] - 2025-01-18

### Added
- Added Docker Compose sample configuration
- Added comprehensive .gitignore rules for Docker cleanup

### Changed
- Enhanced README with detailed build guide
- Refactored Docker build with versioning

### Fixed
- Fixed makefile prune action
- Fixed compose syntax issues

## [v0.1] - 2024-12-18

### Added
- Initial project setup with customized PostgreSQL-based vector database
- Created Dockerfile with PostgreSQL 17 base
- Added basic Makefile for build automation
- Set up initial documentation in README.md
