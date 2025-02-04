import schemathesis
import random
import time
import os


@schemathesis.auth()
class MyAuth:
    def get(self, case, context):
        # need to return something except `None`
        return 1

    def set(self, case, data, context):
        security_definitions = case.operation.definition.raw.get("security", [])
        # randomly choose what kind of authentication would be applied
        random.seed(time.time())
        choosen_auth = random.choice(security_definitions)
        if "NoAuthorization" in choosen_auth:
            case.headers.pop("Authorization", None)
            case.headers.pop("X-API-Key", None)
        if "CatalystRBACSecurityScheme" in choosen_auth:
            case.headers.pop("X-API-Key", None)
            # add RBAC token generation
            pass
        if "InternalApiKeyAuthorization" in choosen_auth:
            case.headers.pop("Authorization", None)
            case.headers["X-API-Key"] = f"{os.getenv("INTERNAL_API_KEY")}"


@schemathesis.check
def ignored_auth_custom(ctx, response, case):
    security_definitions = case.operation.definition.raw.get("security", [])
    if (
        any("NoAuthorization" in sec for sec in security_definitions)
        and 200 <= response.status_code < 300
    ):
        # If 'NoAuthorization' is in the security definitions and status code is 2** skip verification
        return None
    else:
        return schemathesis.specs.openapi.checks.ignored_auth(ctx, response, case)
