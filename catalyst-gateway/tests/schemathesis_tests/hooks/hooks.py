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


@schemathesis.check
def negative_data_rejection_custom(ctx, response, case):
    try:
        return schemathesis.specs.openapi.checks.negative_data_rejection(
            ctx, response, case
        )
    except Exception as e:
        print("")
        print("negative_data_rejection_custom")
        print("path_parameters", case.path_parameters)
        print("headers", case.headers)
        print("cookies", case.cookies)
        print("query", case.query)
        print("body", case.body)
        print(
            f"headers: {case.meta.headers} query: {case.meta.query} path_parameters: {case.meta.path_parameters} cookies: {case.meta.cookies} body: {case.meta.body}"
        )
        for name, value in case.headers.items():
            try:
                schemathesis.cli.callbacks._validate_header(name, value, "")
                print("negative_data_rejection_custom Valid header")
            except Exception as e:
                print(f"negative_data_rejection_custom {e}")
                pass
        raise e
