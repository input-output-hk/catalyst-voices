from integration import CAT_GATEWAY_TEST_URL

def cat_gateway_endpoint_url(endpoint: str):
    return f"{CAT_GATEWAY_TEST_URL}/{endpoint}"