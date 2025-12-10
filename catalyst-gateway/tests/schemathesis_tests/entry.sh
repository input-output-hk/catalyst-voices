#!/bin/sh

st run --checks=all ${API_SPEC} \
                    --exclude-path-regex '.*\/draft\/.*' \
                    --exclude-path '/api/v1/health/inspection' \
                    --exclude-checks=ignored_auth \
                    --exclude-checks=negative_data_rejection \
                    --exclude-checks=not_a_server_error \
                    --workers=2 \
                    --wait-for-schema=${WAIT_FOR_SCHEMA} \
                    --max-response-time=${MAX_RESPONSE_TIME} \
                    --hypothesis-max-examples=${HYPOTHESIS_MAX_EXAMPLES} \
                    --hypothesis-deadline=${HYPOTHESIS_DEADLINE:-15000} \
                    --data-generation-method=all \
                    --exclude-deprecated \
                    --force-schema-version=30 \
                    --show-trace \
                    --force-color  \
                    --junit-xml=/results/junit-report.xml \
                    --cassette-path=/results/cassette.yaml \
                    ${SEED:-}
