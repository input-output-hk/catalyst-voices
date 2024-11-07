// Debug target.
// Always fails, message is all the parameters it received.
import { createRulesetFunction } from "@stoplight/spectral-core";

export default createRulesetFunction(
    {
        input: null,
        options: {
            type: "object",
            additionalProperties: true
        }
    },
    (input, options, context) => {
        const { ...args } = options;
        const { document, documentInventory, rule, path } = context;

        return [
            // this JSON.stringify causes the linter to freeze.
            // it'd be better to use console.log instead.
            {
                message: `input: ${JSON.stringify(input)}`,
            },
        ];
    },
);