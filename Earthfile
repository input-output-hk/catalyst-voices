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
 
global-cargo-config:
    # Needed to get the global cargo config when building rust.
    # All because Earthly doesn't support copying files from parents.
    FROM scratch
    COPY --dir .cargo .cargo
    SAVE ARTIFACT .cargo .cargo
