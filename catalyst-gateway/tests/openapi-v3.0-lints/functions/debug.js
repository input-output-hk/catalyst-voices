// Debug target.
// Always fails, message is all the parameters it received.
import { createRulesetFunction } from "@stoplight/spectral-core";

export default createRulesetFunction(
    {
        input: null,
        options: {
            type: 'object',
            properties: {
                context: {
                    type: 'boolean',
                    description: 'Debug print the context',
                    default: false
                },
            },
            additionalProperties: true
        }
    },
    (input, options, context) => {
        console.log('------ DEBUG ----------------------------------------------------------------')
        console.log('input', input);
        console.log('options', options);
        if (options.context) {
            console.log('context', context);
        }
    },
);