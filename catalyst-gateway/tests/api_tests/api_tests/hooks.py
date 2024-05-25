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
    for key in paths.keys(): 
        values = dict(raw_schema["paths"][key])
        if "get" in values:
            ref_info = raw_schema["paths"][key]["get"]
            new_info = copy.deepcopy(ref_info)
            new_info["responses"] = {"405": {"description": "method not allowed"}}
            raw_schema["paths"][key] = {"get": ref_info, "post": new_info}

        else:
            ref_info = raw_schema["paths"][key]["post"]
            new_info = copy.deepcopy(ref_info)
            new_info["responses"] = {"405": {"description": "method not allowed"}}
            raw_schema["paths"][key] = {"post": ref_info, "get": new_info}
