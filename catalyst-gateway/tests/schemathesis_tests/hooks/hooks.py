import copy
import schemathesis
import schemathesis.schemas
from typing import Any, Dict


@schemathesis.hook
def before_load_schema(
    context: schemathesis.hooks.HookContext,
    raw_schema: Dict[str, Any],
) -> None:
    paths = dict(raw_schema["paths"])
    for endpoint in paths.keys():
        endpoint_data = dict(raw_schema["paths"][endpoint])

        # Get first method data as reference
        ref_info = next(iter(endpoint_data.values()))

        # Create new method data using reference data, replacing 'responses' field
        new_info = copy.deepcopy(ref_info)
        new_info["responses"] = {"405": {"description": "method not allowed"}}

        # Update endpoint if a method is not declared
        if "get" not in endpoint_data:
            endpoint_data.update(
                [
                    ("get", new_info),
                ]
            )
        if "post" not in endpoint_data:
            endpoint_data.update(
                [
                    ("post", new_info),
                ]
            )
        if "put" not in endpoint_data:
            endpoint_data.update(
                [
                    ("put", new_info),
                ]
            )
        if "patch" not in endpoint_data:
            endpoint_data.update(
                [
                    ("patch", new_info),
                ]
            )
        if "delete" not in endpoint_data:
            endpoint_data.update(
                [
                    ("delete", new_info),
                ]
            )

        # Update endpoint
        raw_schema["paths"][endpoint] = endpoint_data


@schemathesis.hooks.register
def before_call(context, case, **kwargs):
    if "NoAuthorization" in context.operation.security:
        # Skip ignored_auth check
        case._checks = [
            check for check in case._checks if check.__name__ != "ignored_auth"
        ]
