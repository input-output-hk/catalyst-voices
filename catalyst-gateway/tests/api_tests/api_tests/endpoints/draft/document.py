import requests
from api_tests import (
    cat_gateway_endpoint_url,
)

URL = cat_gateway_endpoint_url("api/draft/document")
# cspell: disable-next-line
TOKEN = "catv1.UJm5ZNT1n7l3_h3c3VXp1R9QAZStRmrxdtYwTrdsxKWIF1hAi3mqbz6dPNiICQCkoXWJs8KCpcaPuE7LE5Iu9su0ZweK_0Qr9KhBNNHrDMCh79-fruK7WyNPYNc6FrjwTPaIAQ"

# Signed document GET
def get(document_id: str):
    document_url = f"{URL}/{document_id}"
    headers = {
        "Authorization": f"Bearer {TOKEN}"
    }

    return requests.get(document_url, headers=headers)

# Signed document PUT
def put(data: str):
    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Content-Type": "application/cbor"
    }
    data = bytes.fromhex(data)
    return requests.put(URL, headers=headers, data=data)

# Signed document POST
def post(document_url: str, filter: dict):
    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Content-Type": "application/json"
    }

    return requests.post(URL+document_url, headers=headers, json=filter)
