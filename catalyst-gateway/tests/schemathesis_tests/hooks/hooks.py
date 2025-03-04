import schemathesis
import random
import time
import os
import hypothesis
import cbor2


@schemathesis.serializer("application/cbor")
class CborSerializer:
    def as_requests(self, context, value):
        data = cbor2.dumps(value)
        return {"data": data}

    def as_werkzeug(self, context, value):
        data = cbor2.dumps(value)
        return {"data": data}


@schemathesis.auth()
class MyAuth:
    def get(self, case, context):
        # need to return something except `None`
        return 1

    def set(self, case, data, context):
        security_definitions = case.operation.definition.raw.get("security", [])
        # randomly choose what kind of authentication would be applied
        choosen_auth_st = hypothesis.strategies.sampled_from(security_definitions)
        choosen_auth = hypothesis.find(choosen_auth_st, lambda x: True)
        if "NoAuthorization" in choosen_auth:
            case.headers.pop("Authorization", None)
            case.headers.pop("X-API-Key", None)
        if "CatalystRBACSecurityScheme" in choosen_auth:
            case.headers.pop("X-API-Key", None)
            # cspell: disable
            rbac_token = "catid.:1740660380@preprod.cardano/ycih6xARcuFGiRrtf1ETLWPvXGd_UBheZ4A5kccWNAU.2CB_ByoGhZ8xBjLveK6jcGbKZ7_5TDjCwbTyNtHWFXnyKuvkTp9zo9tmBOVkPRbHjSwzx85kX3lIoGtKF3_dDQ"
            # cspell: enable
            case.headers["Authorization"] = f"Bearer {rbac_token}"
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
    responses = case.operation.definition.raw.get("responses", {})
    status_codes = responses.keys()

    # correctly setup allowed status codes for negative_data_rejection check
    ctx.config.negative_data_rejection.allowed_statuses = list(
        [code for code in status_codes if code.startswith("4")]
    )
    # Allow 503 status for this validation
    ctx.config.negative_data_rejection.allowed_statuses.append("503")

    if case.data_generation_method and case.data_generation_method.is_negative:
        # if only headers are included
        if (
            case.headers != None
            and case.path_parameters == None
            and case.cookies == None
            and case.query == None
            and isinstance(case.body, schemathesis.types.NotSet)
        ):
            isValid = True
            for name, value in case.headers.items():
                try:
                    schemathesis.cli.callbacks._validate_header(name, value, "")
                except:
                    isValid = False
                    break
            # if all headers are valid skip verification
            if isValid:
                return None

    return schemathesis.specs.openapi.checks.negative_data_rejection(
        ctx, response, case
    )


@schemathesis.check
def not_a_server_error_custom(ctx, response, case):
    # Allow 503 status for this validation
    if response.status_code == 503:
        return None

    return schemathesis.checks.not_a_server_error(ctx, response, case)
