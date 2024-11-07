import { createRulesetFunction } from "@stoplight/spectral-core";

export default createRulesetFunction(
    {
        input: null,
        options: {
            type: "object",
        },
    },
    (input, options) => {
        const errors = [];
        const {} = options;

        const testDescriptionValidity = (value, errors) => {
            if (!value || value.length < 20) {
                errors.push({
                    message: `Description with minimum length of 20 characters must be defined`,
                })
            }
        };

        // check if 'description' or 'schema.description' exists in the ParameterObject
        if ("in" in input && input.in === "query") {
            if (input.description) {
                testDescriptionValidity(input.description, errors);
            }
            else if (input.schema && input.schema.description) {
                testDescriptionValidity(input.schema.description, errors);
            }
            else {
                errors.push({
                    message: `'description' or 'schema.description' is missing in the ParameterObject.`
                })
            }
        }
        // check if description exists
        else {
            testDescriptionValidity(input.description, errors);
        }

        if (errors.length) {
            return errors;
        }
    },
);
