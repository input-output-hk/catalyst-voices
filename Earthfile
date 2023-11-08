# Set the Earthly version to 0.7

VERSION 0.7
FROM debian:stable-slim

# cspell: words livedocs sitedocs

markdown-check:
    # Check Markdown in this repo.
    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:v1.3.0+MDLINT_LOCALLY --src=$(echo ${PWD})

markdown-check-fix:
    # Check Markdown in this repo.
    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:v1.3.0+MDLINT_LOCALLY --src=$(echo ${PWD}) --fix=--fix

spell-check:
    # Check spelling in this repo.
    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/cspell:v1.3.0+CSPELL_LOCALLY --src=$(echo ${PWD})
 
repo-docs:
    # Create artifacts of extra files we embed inside the documentation when its built.
    FROM scratch

    WORKDIR /repo
    COPY --dir *.md LICENSE-APACHE LICENSE-MIT .

    SAVE ARTIFACT /repo repo
