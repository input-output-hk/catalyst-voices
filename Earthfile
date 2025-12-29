VERSION 0.8

IMPORT github.com/input-output-hk/catalyst-ci/earthly/mdlint:v3.6.10 AS mdlint-ci
IMPORT github.com/input-output-hk/catalyst-ci/earthly/cspell:v3.6.10 AS cspell-ci
IMPORT github.com/input-output-hk/catalyst-ci/earthly/postgresql:v3.6.10 AS postgresql-ci

ARG --global REGISTRY="harbor.shared-services.projectcatalyst.io/dockerhub/library"
FROM ${REGISTRY}/debian:stable-slim

# cspell: words livedocs sitedocs

# check-markdown markdown check using catalyst-ci.
check-markdown:
    DO mdlint-ci+CHECK

# markdown-check-fix markdown check and fix using catalyst-ci.
markdown-check-fix:
    LOCALLY

    DO mdlint-ci+MDLINT_LOCALLY --src=$(echo ${PWD}) --fix=--fix

# clean-spelling-list : Make sure the project dictionary is properly sorted.
clean-spelling-list:
    DO cspell-ci+CLEAN

# check-spelling Check spelling in this repo inside a container.
check-spelling:
    DO cspell-ci+CHECK

# check if the sql files are properly formatted and pass lint quality checks.
check-sqlfluff:
    FROM postgresql-ci+sqlfluff-base

    COPY . .

    DO postgresql-ci+CHECK

repo-docs:
    # Create artifacts of extra files we embed inside the documentation when its built.
    FROM scratch

    WORKDIR /repo
    COPY --dir *.md LICENSE-APACHE LICENSE-MIT .

    SAVE ARTIFACT /repo repo

# copy-docs : Copy the docs source folder.
copy-docs:
    FROM scratch
    COPY --dir docs/src ./docs/src
    SAVE ARTIFACT /docs docs