import { createRulesetFunction } from "@stoplight/spectral-core";

export default createRulesetFunction(
    {
        input: null,
        options: {
            type: "object",
        },
    },
    (targetVal, options) => {
        const errors = [];
        const {} = options;

        const testDescriptionValidity = (value, errors) => {
            if (!value || value.length < 20) {
                errors.push({
                    message: `Description with minimum length of 20 characters must be defined`,
                })
            }
        };

        // check if description or description.description exists in the ParameterObject
        if ("in" in targetVal && targetVal.in === "query") {
            if (targetVal.description) {
                testDescriptionValidity(targetVal.description, errors);
            }
            else if (targetVal.schema && targetVal.schema.description) {
                testDescriptionValidity(targetVal.schema.description, errors);
            }
            else {
                errors.push({
                    message: `'description' or 'schema.description' is missing in the ParameterObject.`
                })
            }
        }
        // check if description exists
        else {
            testDescriptionValidity(targetVal.description, errors);
        }

        if (errors.length) {
            return errors;
        }
    },
);
