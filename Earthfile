VERSION 0.8

IMPORT github.com/input-output-hk/catalyst-ci/earthly/mdlint:v3.00.0 AS mdlint-ci
IMPORT github.com/input-output-hk/catalyst-ci/earthly/cspell:v3.00.0 AS cspell-ci
IMPORT github.com/input-output-hk/catalyst-ci/earthly/postgresql:v3.00.0 AS postgresql-ci
IMPORT github.com/input-output-hk/catalyst-ci/earthly/flutter:v3.1.5 AS flutter-ci

FROM debian:stable-slim

# cspell: words livedocs sitedocs

# check-markdown markdown check using catalyst-ci.
check-markdown:
    DO mdlint-ci+CHECK

# markdown-check-fix markdown check and fix using catalyst-ci.
markdown-check-fix:
    LOCALLY

    DO mdlint-ci+MDLINT_LOCALLY --src=$(echo ${PWD}) --fix=--fix

# check-spelling Check spelling in this repo inside a container.
check-spelling:
    DO cspell-ci+CHECK

# check if the sql files are properly formatted and pass lint quality checks.
check-sqlfluff:
    FROM postgresql-ci+postgres-base

    COPY . .

    DO postgresql-ci+CHECK

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

# license-checker-base - Base image for license checker.
license-checker-base:
    FROM flutter-ci+license-checker-base
    COPY +repo-catalyst-voices-all/repo .
    DO flutter-ci+BOOTSTRAP

LICENSE_CHECK:
    FUNCTION
    FROM +license-checker-base
    # Path of the package that needs to be checked for licenses
    ARG --required path
    # template_license_checker.yaml needs to be present in the same directory as the path
    RUN mv template_license_checker.yaml $path/template_license_checker.yaml
    WORKDIR $path
    DO flutter-ci+LICENSE_CHECK