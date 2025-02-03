import schemathesis


@schemathesis.check
def ignored_auth_custom(ctx, response, case):
    security_definitions = case.operation.definition.raw.get("security", [])
    if any("NoAuthorization" in sec for sec in security_definitions):
        # If 'NoAuthorization' is in the security definitions skip verification
        return None
    else:
        return schemathesis.specs.openapi.checks.ignored_auth(ctx, response, case)
