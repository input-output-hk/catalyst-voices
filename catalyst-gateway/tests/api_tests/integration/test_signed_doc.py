import pytest
from loguru import logger
from utils import health
from api.v1 import document

def test_signed_doc():
    health.is_live()
    health.is_ready()

    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d8255001946ea1818a7e0eb6b16169f02ffd4ea0581c8b0b807b22616765223a32392c226e616d65223a22416c6578227d0380"
    # Put a signed document
    resp = document.put(data=signed_doc)
    assert (201 <= resp.status_code <= 204,
            f"Failed to publish document: {resp.status_code} - {resp.text}")
    # Put a signed document again
    resp = document.put(data=signed_doc)
    assert (resp.status_code == 204,
            f"Failed to publish document: {resp.status_code} - {resp.text}")
    # Get the signed document
    resp = document.get(document_id="01946ea1-818a-7e0e-b6b1-6169f02ffd4e")
    assert (resp.status_code == 200,
            f"Failed to get document: {resp.status_code} - {resp.text}")
    # Post a signed document with filter ID
    resp = document.post("/index",
                         filter={"id": {"eq": "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"}})
    assert (resp.status_code == 200,
            f"Failed to post document: {resp.status_code} - {resp.text}")
    # Put a signed document with same ID different content
    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d8255001946ea1818a7e0eb6b16169f02ffd4ea0581c8b0b807b22616765223a33302c226e616d65223a22416c6578227d0380"
    resp = document.put(data=signed_doc)
    assert (resp.status_code == 422,
            f"Publish document, expected 422 Unprocessable Content: {resp.status_code} - {resp.text}")

    # Put a signed document with same ID, but different version
    signed_doc = "84585fa6012703183270436f6e74656e742d456e636f64696e676262726474797065d82550913c9265f9f944fcb3cf9d9516ae9baf626964d8255001946ea1818a7e0eb6b16169f02ffd4e63766572d825500194d649960076639ebc1613291cf25fa0581c8b0b807b22616765223a32392c226e616d65223a22416c6578227d0380"
    resp = document.put(data=signed_doc)
    assert (201 <= resp.status_code <= 204,
            f"Failed to publish document: {resp.status_code} - {resp.text}")

    # Pagination out of range
    resp = document.post(
            "/index?page=92233720368547759",
            filter={"id": {"eq": "01946ea1-818a-7e0e-b6b1-6169f02ffd4e"}}
            )
    assert (resp.status_code == 412,
            f"Post document, expected 412 Precondition Failed: {resp.status_code} - {resp.text}")

    logger.info("Signed document test successful.")
