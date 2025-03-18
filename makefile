# Makefile
BUILD_VERSION ?= 0.2

# Define the version variables
PG_SEARCH_VERSION ?= 0.13.1
PG_VECTORSCALE_VERSION ?= 0.5.1
PGVECTOR_BASE_VERSION ?= 0.8.0

# Define PostgreSQL major versions to build for
PG_VERSIONS := 14 15 16 17

# Define the base image URL with PG_MAJOR_VERSION
define PG_VECTOR_BASE_VERSION
$(PGVECTOR_BASE_VERSION)-pg$(version)
endef

# --------------------------- Docker Build Tags ---------------------------
# Define the build tag, default to 0.1-pg{PG_MAJOR_VERSION}
define BUILD_TAG
$(BUILD_VERSION)-pg$(version)
endef

define LATEST_TAG
latest-pg$(version)
endef

# ---------------------------- Dependency URLs ----------------------------
# Define the URLs for the deb files with version variables and PG_MAJOR_VERSION
define PG_SEARCH_URL
"https://github.com/paradedb/paradedb/releases/download/v$(PG_SEARCH_VERSION)/postgresql-$(version)-pg-search_$(PG_SEARCH_VERSION)-1PARADEDB-bookworm_amd64.deb"
endef

define PGVECTORSCALE_ZIP_URL
"https://github.com/timescale/pgvectorscale/releases/download/$(PG_VECTORSCALE_VERSION)/pgvectorscale-$(PG_VECTORSCALE_VERSION)-pg$(version)-amd64.zip"
endef

# ------------------------------ Local Paths ------------------------------
# Define the local paths for the deb files
PG_SEARCH_DEB := pg_search.deb
PGVECTORSCALE_DEB := pgvectorscale.deb

# Download the deb files
.PHONY: download
download: $(PG_SEARCH_DEB) $(PGVECTORSCALE_DEB)

$(PG_SEARCH_DEB):
	$(foreach version,$(PG_VERSIONS), \
		echo "Downloading pg_search.deb for PostgreSQL $(version) from $(PG_SEARCH_URL)"; \
		curl -L $(PG_SEARCH_URL) -o $(PG_SEARCH_DEB); \
	)

$(PGVECTORSCALE_DEB):
	$(foreach version,$(PG_VERSIONS), \
		echo "Downloading pgvectorscale.zip for PostgreSQL $(version) from $(PGVECTORSCALE_ZIP_URL)"; \
		curl -L $(PGVECTORSCALE_ZIP_URL) -o pgvectorscale.zip; \
		unzip -j pgvectorscale.zip "pgvectorscale-postgresql-$(version)_$(PG_VECTORSCALE_VERSION)-Linux_amd64.deb" -d .; \
		mv pgvectorscale-postgresql-$(version)_$(PG_VECTORSCALE_VERSION)-Linux_amd64.deb $(PGVECTORSCALE_DEB); \
		rm -f pgvectorscale.zip; \
	)

# Build the Docker image
.PHONY: build
build: download
	$(foreach version,$(PG_VERSIONS), \
		echo "Building Docker image for PostgreSQL $(version)"; \
		docker build --build-arg PG_VECTOR_BASE_VERSION=$(PG_VECTOR_BASE_VERSION) -t oaklight/vectorsearch:$(BUILD_TAG) .; \
		docker tag oaklight/vectorsearch:$(BUILD_TAG) oaklight/vectorsearch:$(LATEST_TAG); \
	)

# Clean up the deb files
.PHONY: clean
clean:
	echo "Cleaning up deb files"
	rm -f $(PG_SEARCH_DEB) $(PGVECTORSCALE_DEB)

# Prune Docker images
.PHONY: prune
prune: clean
	$(foreach version,$(PG_VERSIONS), \
		echo "Pruning Docker images for PostgreSQL $(version)"; \
		docker rmi oaklight/vectorsearch:$(BUILD_TAG); \
		docker rmi oaklight/vectorsearch:$(LATEST_TAG); \
	)

# Push Docker images to Docker Hub
.PHONY: push
push: build
	$(foreach version,$(PG_VERSIONS), \
		echo "Pushing Docker images for PostgreSQL $(version)"; \
		docker push oaklight/vectorsearch:$(BUILD_TAG); \
		docker push oaklight/vectorsearch:$(LATEST_TAG); \
	)
