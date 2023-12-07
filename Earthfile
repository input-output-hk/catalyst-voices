# Set the Earthly version to 0.7

VERSION 0.7
FROM debian:stable-slim

# cspell: words livedocs sitedocs

# check-markdown markdown check using catalyst-ci.
check-markdown:
    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:v2.0.10+CHECK

# markdown-check-fix markdown check and fix using catalyst-ci.
markdown-check-fix:
    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:v2.0.10+MDLINT_LOCALLY --src=$(echo ${PWD}) --fix=--fix

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
