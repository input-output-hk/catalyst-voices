# Set the Earthly version to 0.7

VERSION 0.7
FROM debian:stable-slim

# cspell: words livedocs sitedocs

# Markdown check in this repo.
# Arguments:
#  * CATALYST_CI_VER: specific version of the `github.com/input-output-hk/catalyst-ci` dep.
#    (Does not need to specify it directrly it is specified in `.arg` file)
markdown-check:
    ARG --required CATALYST_CI_VER

    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:$CATALYST_CI_VER+MDLINT_LOCALLY --src=$(echo ${PWD})

# Markdown check fix in this repo.
# Arguments:
#  * CATALYST_CI_VER: specific version of the `github.com/input-output-hk/catalyst-ci` dep.
#    (Does not need to specify it directrly it is specified in `.arg` file)
markdown-check-fix:
    ARG --required CATALYST_CI_VER

    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/mdlint:$CATALYST_CI_VER+MDLINT_LOCALLY --src=$(echo ${PWD}) --fix=--fix

# Check spelling in this repo.
# Arguments:
#  * CATALYST_CI_VER: specific version of the `github.com/input-output-hk/catalyst-ci` dep.
#    (Does not need to specify it directrly it is specified in `.arg` file)
spell-check:
    ARG --required CATALYST_CI_VER

    LOCALLY

    DO github.com/input-output-hk/catalyst-ci/earthly/cspell:$CATALYST_CI_VER+CSPELL_LOCALLY --src=$(echo ${PWD})
 