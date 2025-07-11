#!/bin/sh

st run --checks=all ${API_SPEC} \
                    --exclude-path-regex '.*\/draft\/.*' \
                    # excluding since this is a internal debug endpoint
                    --exclude-path '/api/v1/health/inspection' \
                    --exclude-checks=ignored_auth \ 
                    # overridden check with negative_data_rejection_custom
                    --exclude-checks=negative_data_rejection \
                    # overridden check with not_a_server_error_custom 
                    --exclude-checks=not_a_server_error \ 
                    --workers=2 \
                    --wait-for-schema=${WAIT_FOR_SCHEMA} \
                    --max-response-time=${MAX_RESPONSE_TIME} \
                    --hypothesis-max-examples=${HYPOTHESIS_MAX_EXAMPLES} \
                    --data-generation-method=all \
                    --exclude-deprecated \
                    --force-schema-version=30 \
                    --show-trace \
                    --force-color  \
                    --junit-xml=/results/junit-report.xml \
                    --cassette-path=/results/cassette.yaml \
                    ${SEED:-}