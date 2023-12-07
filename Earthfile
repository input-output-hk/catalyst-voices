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

    DO github.com/input-output-hk/catalyst-ci/earthly/cspell:v2.0.10+CSPELL_LOCALLY --src=$(echo ${PWD})

# check-spelling Check spelling in this repo inside a container.
check-spelling:
    DO github.com/input-output-hk/catalyst-ci/earthly/cspell:v2.0.10+CHECK

check:
    BUILD +check-spelling
 
repo-docs:
    # Create artifacts of extra files we embed inside the documentation when its built.
    FROM scratch

    WORKDIR /repo
    COPY --dir *.md LICENSE-APACHE LICENSE-MIT .

    SAVE ARTIFACT /repo repo
