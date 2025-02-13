import pytest
from loguru import logger

from api_tests import (
    check_is_live,
    check_is_ready,
)

from endpoints.draft import document
URL = "api/draft/document"
# cspell: disable-next-line
TOKEN = "catv1.UJm5ZNT1n7l3_h3c3VXp1R9QAZStRmrxdtYwTrdsxKWIF1hAi3mqbz6dPNiICQCkoXWJs8KCpcaPuE7LE5Iu9su0ZweK_0Qr9KhBNNHrDMCh79-fruK7WyNPYNc6FrjwTPaIAQ"

def test_signed_doc():
    check_is_live()
    check_is_ready()

    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d8255001946ea1818a7e0eb6b16169f02ffd4ea0581c8b0b807b22616765223a32392c226e616d65223a22416c6578227d0380"
    # Put a signed document
    resp = document.put(data=signed_doc)
    assert 201 <= resp.status_code <= 204, f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Put a signed document again
    resp = document.put(data=signed_doc)
    assert resp.status_code == 204, f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Get the signed document
    resp = document.get(document_id="01946ea1-818a-7e0e-b6b1-6169f02ffd4e")
    assert resp.status_code == 200, f"Failed to get document: {resp.status_code} - {resp.text}"

    # Post a signed document with filter ID
    resp = document.post(url=f"{URL}/index", filter={"id": {"eq": "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"}})
    assert resp.status_code == 200, f"Failed to post document: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID different content
    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d8255001946ea1818a7e0eb6b16169f02ffd4ea0581c8b0b807b22616765223a33302c226e616d65223a22416c6578227d0380"
    resp = document.put(data=signed_doc)
    assert resp.status_code == 422, f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}"

    # Put a signed document with same ID, but different version
    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d825500194d649960076639ebc1613291cf25fa0581c8b0b807b22616765223a32392c226e616d65223a22416c6578227d0380"
    resp = document.put(data=signed_doc)
    assert 201 <= resp.status_code <= 204, f"Failed to publish document: {resp.status_code} - {resp.text}"

    # Pagination out of range
    resp = document.post(url="/index?page=92233720368547759",filter={"id": {"eq": "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"}})
    assert resp.status_code == 412, f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}"

    logger.info("Signed document test successful.")
