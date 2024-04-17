# Set the Earthly version to 0.7

VERSION 0.7
FROM debian:stable-slim

# cspell: words livedocs sitedocs

# check-markdown markdown check using catalyst-ci.
check-markdown:
    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:v2.11.1+CHECK

# markdown-check-fix markdown check and fix using catalyst-ci.
markdown-check-fix:
    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:v2.11.1+MDLINT_LOCALLY --src=$(echo ${PWD}) --fix=--fix

# check-spelling Check spelling in this repo inside a container.
check-spelling:
    DO github.com/input-output-hk/catalyst-ci/earthly/cspell:v2.11.1+CHECK

# check if the sql files are properly formatted and pass lint quality checks.
check-sqlfluff:
    FROM github.com/input-output-hk/catalyst-ci/earthly/postgresql:v2.11.1+postgres-base

    COPY . .

    DO github.com/input-output-hk/catalyst-ci/earthly/postgresql:v2.11.1+CHECK

repo-docs:
    # Create artifacts of extra files we embed inside the documentation when its built.
    FROM scratch

    WORKDIR /repo
    COPY --dir *.md LICENSE-APACHE LICENSE-MIT .

    SAVE ARTIFACT /repo repo

# repo-catalyst-voices-packages - Create artifacts of catalyst_voices_packages
# we need to refer to in other earthly targets.
repo-catalyst-voices-packages:
    FROM scratch

    WORKDIR /repo
    COPY --dir catalyst_voices_packages .

    SAVE ARTIFACT /repo repo

# repo-catalyst-voices-all - Creates artifacts of all configuration files,
# packages and folders related to catalyst_voices frontend.
repo-catalyst-voices-all:
    FROM scratch

    WORKDIR /repo
    COPY --dir catalyst_voices catalyst_voices_packages utilities melos.yaml pubspec.yaml  .

    SAVE ARTIFACT /repo repo