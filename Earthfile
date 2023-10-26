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

local-development-setup:
    # Build Container we need to serve live docs.
    #BUILD ./docs+mkdocs-material
    # Builds the static site-docs.
    BUILD ./docs+local-build

    # Installs things local developers will need.
    DO github.com/input-output-hk/catalyst-ci/earthly/docs:t1+DEVELOP --dest=./local

live-docs-development:
    LOCALLY

    # We use python to open a browser on Windows/Mac or Linux
    RUN python -c "import webbrowser; webbrowser.open('http://localhost:10080')"
    RUN docker compose -f local/docker-compose.livedocs.yml up --abort-on-container-exit

site-docs-development:
    LOCALLY

    # We use python to open a browser on Windows/Mac or Linux
    RUN python -c "import webbrowser; webbrowser.open('http://localhost:10081')"
    RUN docker compose -f local/docker-compose.sitedocs.yml up --abort-on-container-exit

repo-docs:
    FROM scratch

    WORKDIR /
    COPY --dir CODE_OF_CONDUCT.md CONTRIBUTING.md LICENSE-APACHE LICENSE-MIT README.md SECURITY.md /repo

    SAVE ARTIFACT /repo repo