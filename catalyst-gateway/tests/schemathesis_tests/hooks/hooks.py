import schemathesis
from schemathesis import hooks, models


@schemathesis.hook
def before_init_operation(context: hooks.HookContext, operation: models.APIOperation):
    # Get security definitions safely
    security_definitions = operation.definition.raw.get("security", [])

    # Check if 'NoAuthorization' is in the security definitions
    if any("NoAuthorization" in sec for sec in security_definitions):
        # Remove ignored_auth check from this specific operation
        operation.checks = [
            check for check in operation.checks if check.__name__ != "ignored_auth"
        ]
