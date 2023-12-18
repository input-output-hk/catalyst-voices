# Set the Earthly version to 0.7

VERSION 0.7
FROM debian:stable-slim

# cspell: words livedocs sitedocs

markdown-check:
    # Check Markdown in this repo.
    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:v2.0.9+MDLINT_LOCALLY --src=$(echo ${PWD})

markdown-check-fix:
    # Check Markdown in this repo.
    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:v2.0.9+MDLINT_LOCALLY --src=$(echo ${PWD}) --fix=--fix

spell-check:
    # Check spelling in this repo.
    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/cspell:v2.0.9+CSPELL_LOCALLY --src=$(echo ${PWD})
 
repo-docs:
    # Create artifacts of extra files we embed inside the documentation when its built.
    FROM scratch

    WORKDIR /repo
    COPY --dir *.md LICENSE-APACHE LICENSE-MIT .

    SAVE ARTIFACT /repo repo

repo-config-2:
    # Create artifacts of config file we need to refer to in builders.
    FROM scratch

    WORKDIR /repo
    COPY --dir .sqlfluff .

    SAVE ARTIFACT /repo repo