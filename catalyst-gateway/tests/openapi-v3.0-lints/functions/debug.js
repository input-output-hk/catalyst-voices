// Debug target.
// Always fails, message is all the parameters it received.
import { createRulesetFunction } from "@stoplight/spectral-core";

export default createRulesetFunction(
    {
        input: {
            type: "object"
        },
        options: {
            type: "object",
        },
        context: RulesetFunctionContext
    },
    (targetVal, options) => {
        const results = [];

        results.push({
            
        })

        const { value } = options;

        if (targetVal !== value) {
            return [
                {
                    message: `Value must equal ${value}.`,
                },
            ];
        }

        return results;
    },
);