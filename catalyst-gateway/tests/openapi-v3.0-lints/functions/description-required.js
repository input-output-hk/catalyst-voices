import { createRulesetFunction } from "@stoplight/spectral-core";
import { printValue } from '@stoplight/spectral-runtime';

// regex in a string like {"match": "/[a-b]+/im"} or {"match": "[a-b]+"} in a json ruleset
// the available flags are "gimsuy" as described here: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp
const REGEXP_PATTERN = /^\/(.+)\/([a-z]*)$/;

const cache = new Map();

function getFromCache(pattern) {
    const existingPattern = cache.get(pattern);
    if (existingPattern !== void 0) {
        existingPattern.lastIndex = 0;
        return existingPattern;
    }

    const newPattern = createRegex(pattern);
    cache.set(pattern, newPattern);
    return newPattern;
}

function createRegex(pattern) {
    const splitRegex = REGEXP_PATTERN.exec(pattern);
    if (splitRegex !== null) {
        // with slashes like /[a-b]+/ and possibly with flags like /[a-b]+/im
        return new RegExp(splitRegex[1], splitRegex[2]);
    } else {
        // without slashes like [a-b]+
        return new RegExp(pattern);
    }
}

export default createRulesetFunction(
    {
        input: null,
        options: {
            type: 'object',
            properties: {
                length: {
                    type: 'integer',
                    description: 'The minimum length of a description.',
                },
                match: {
                    type: 'string',
                    description: 'regex that target must match.',
                },
                noMatch: {
                    type: 'string',
                    description: 'regex that target must not match.',
                },
            },
            additionalProperties: false,
        },
    },
    (input, options, context) => {
        let results = [];
        const { } = options;

        const testDescriptionValidity = (value) => {
            if (!value) {
                (results ??= []).push({
                    message: `Description must exist`,
                });
            }

            if ('length' in options) {
                if (value.length < options.length) {
                    (results ??= []).push({
                        message: `Description must have length >= ${printValue(options.length)} characters`,
                    })
                }
            }

            if ('match' in options) {
                const pattern = getFromCache(options.match);

                if (!pattern.test(value)) {
                    (results ??= []).push({
                        message: `${printValue(value)} must match the pattern ${printValue(options.match)}`,
                    })
                }
            }

            if ('noMatch' in options) {
                const pattern = getFromCache(options.noMatch);

                if (pattern.test(value)) {
                    (results ??= []).push({
                        message: `${printValue(value)} must NOT match the pattern ${printValue(options.noMatch)}`,
                    })
                }
            }
        };

        // check if 'description' or 'schema.description' exists in the ParameterObject
        if (input.description) {
            testDescriptionValidity(input.description);
        } else if ("in" in input && input.in === "query") {
            if ("schema" in input && "description" in input.schema) {
                testDescriptionValidity(input.schema.description);
            } else {
                (results ??= []).push({
                    message: `'description' or 'schema.description' is missing in the Query Parameter.`
                })
            }
        }
        else {
            (results ??= []).push({
                message: `'description' is missing.`
            })
        }

        if (results.length) {
            return results;
        }
    },
);
