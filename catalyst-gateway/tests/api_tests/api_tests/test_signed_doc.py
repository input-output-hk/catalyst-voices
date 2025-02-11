import requests
import pytest
from loguru import logger

from api_tests import (
    cat_gateway_endpoint_url,
    check_is_live,
    check_is_ready,
)

URL = "api/draft/document"
# cspell: disable-next-line
TOKEN = "catv1.UJm5ZNT1n7l3_h3c3VXp1R9QAZStRmrxdtYwTrdsxKWIF1hAi3mqbz6dPNiICQCkoXWJs8KCpcaPuE7LE5Iu9su0ZweK_0Qr9KhBNNHrDMCh79-fruK7WyNPYNc6FrjwTPaIAQ"

@pytest.mark.ci
def test_signed_doc():
    check_is_live()
    check_is_ready()

    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d8255001946ea1818a7e0eb6b16169f02ffd4ea0581c8b0b807b22616765223a32392c226e616d65223a22416c6578227d0380"
    # Put a signed document
    resp = put_signed_doc(data=signed_doc)
    assert 201 <= resp.status_code <= 204, f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a signed document again
    resp = put_signed_doc(data=signed_doc)
    assert resp.status_code == 204, f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Get the signed document
    resp = get_signed_doc(document_id="01946ea1-818a-7e0e-b6b1-6169f02ffd4e")
    assert resp.status_code == 200, f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = post_signed_doc(url=f"{URL}/index", filter={"id": {"eq": "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"}})
    assert resp.status_code == 200, f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID different content
    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d8255001946ea1818a7e0eb6b16169f02ffd4ea0581c8b0b807b22616765223a33302c226e616d65223a22416c6578227d0380"
    resp = put_signed_doc(data=signed_doc)
    assert resp.status_code == 422, f"Publish document, expected Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID, but different version
    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d825500194d649960076639ebc1613291cf25fa0581c8b0b807b22616765223a32392c226e616d65223a22416c6578227d0380"
    resp = put_signed_doc(data=signed_doc)
    assert 201 <= resp.status_code <= 204, f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Pagination out of range
    resp = post_signed_doc(url=f"{URL}/index?page=92233720368547759",filter={"id": {"eq": "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"}})
    assert resp.status_code == 400, f"Post document, expected BadRequest: {resp.status_code} - {resp.text}"

    logger.info("Signed document test successful.")

# Signed document GET
def get_signed_doc(document_id: str):
    url = f"{URL}/{document_id}"
    headers = {
        "Authorization": f"Bearer {TOKEN}"
    }

    return requests.get(cat_gateway_endpoint_url(url), headers=headers)

# Signed document PUT
def put_signed_doc(data: str):
    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Content-Type": "application/cbor"
    }
    data = bytes.fromhex(data)
    return requests.put(cat_gateway_endpoint_url(URL), headers=headers, data=data)

# Signed document POST
def post_signed_doc(url: str, filter: dict):
    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Content-Type": "application/json"
    }

    return requests.post(cat_gateway_endpoint_url(url), headers=headers, json=filter)
