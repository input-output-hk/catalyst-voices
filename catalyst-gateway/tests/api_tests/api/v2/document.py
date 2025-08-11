import requests
from api import cat_gateway_endpoint_url

URL = cat_gateway_endpoint_url("api/v2/document")


# Signed document POST
def post(filter: dict, limit=None, page=None):
    headers = {"Content-Type": "application/json"}
    url = f"{URL}/index"
    query_params = []
    if limit is not None:
        query_params.append(f"limit={limit}")
    if page is not None:
        query_params.append(f"page={page}")

    if query_params:
        url += "?" + "&".join(query_params)
    return requests.post(url, headers=headers, json=filter)
