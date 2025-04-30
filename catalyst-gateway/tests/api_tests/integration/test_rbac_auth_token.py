# Before running this test, unset RBAC_OFF environment variable

import pytest
import requests
from utils import health, sync
from utils.rbac_chain import rbac_chain_factory, RoleID, RBACChain
from datetime import datetime, timezone, timedelta
from api.v1.rbac import get

@pytest.mark.preprod_indexing
def test_invalid_rbac_auth_token(rbac_chain_factory):
    # Token doesn't start with catid. -> 401
    resp = get(lookup=None, token="invalid")
    assert(resp.status_code == 401), f"Expected missing token prefix: {resp.status_code} - {resp.text}"

    # Missing signature -> 401
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    # Removing the . so cant distinct between token and signature (but not the . in prefix)
    head, sep, tail = token.partition(".")
    token = head + sep + tail.replace(".", "")
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected missing token signature: {resp.status_code} - {resp.text}"
    
    # Signature invalid length -> 401
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token(sig="abcd")
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected invalid length signature: {resp.status_code} - {resp.text}"
    
    # Signature is not a base64 url, but role 0 pk is in correct format -> 401
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    # Pad last string to corrupt the safe base64 url format
    resp = get(lookup=None, token=token[:-1] + "=")
    assert(resp.status_code == 401), f"Expected invalid signature: {resp.status_code} - {resp.text}"
    
    # Text after `catid.` is not a Catalyst ID -> 401
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token(cid="notacatid")
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected invalid Catalyst ID: {resp.status_code} - {resp.text}"

    # Auth token has username -> 401
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token(username="bob")
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected must not contain username: {resp.status_code} - {resp.text}"
    
    # Catalyst ID not in a correct format -> 401
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token(is_uri=True)
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected invalid Catalyst ID format: {resp.status_code} - {resp.text}"
    
    # Catalyst ID part doesn't contain nonce -> 401
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token(nonce="")
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected nonce: {resp.status_code} - {resp.text}"

    # Catalyst ID part contain role -> 401
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    # Split catid and signature and add role
    head, tail = token.rsplit(".", 1)
    resp = get(lookup=None, token=f"{head}/0.{tail}")
    assert(resp.status_code == 401), f"Expected no role: {resp.status_code} - {resp.text}"    
    # Catalyst ID part contain rotation -> 401
    resp = get(lookup=None, token=f"{head}/0/0.{tail}")
    assert(resp.status_code == 401), f"Expected no rotation: {resp.status_code} - {resp.text}"
    
    # Unsupported network -> 401
    token = rbac_chain_factory(RoleID.ROLE_0, "test").auth_token()
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected unsupported network: {resp.status_code} - {resp.text}"

    # Unsupported subnet -> 401
    token = rbac_chain_factory(RoleID.ROLE_0, "cardano", "test").auth_token()
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected unsupported subnet: {resp.status_code} - {resp.text}"

    # Role 0 key is not registered in the given network (not found in the database) - 401
    # cspell:disable-next-line
    token = "catid.:1744706738@preprod.cardano/bFPjLMdjds6aeHPniAgqtDGyBpfoabj2nPpSQQByrig.mTOqN73XYFiJRqrjkS7zwGFkyS5KHzijGE-xVIllGNDHKYRGfWeu9PIkEVoY0FpqkRbUsRVe755jRcSTsWP2AA"
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 401), f"Expected key not registered: {resp.status_code} - {resp.text}"
    
    # Nonce is not in a range -> 403
    nonce = int((datetime.now(timezone.utc) - timedelta(days=30)).timestamp())  
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token(nonce=nonce)
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 403), f"Expected nonce expired: {resp.status_code} - {resp.text}"
    
    # Signature verification, not valid signature -> 403.
    sig = "a" * 64
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token(sig=sig)
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 403), f"Expected invalid signature: {resp.status_code} - {resp.text}"

@pytest.mark.preprod_indexing
def test_valid_rbac_auth_token(rbac_chain_factory):
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 200), f"Expected valid token that already registered: {resp.status_code} - {resp.text}"
    
    # X-API-Key does not match as expected value, but still pass because the nonce is valid
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    resp = get(lookup=None, token=token, extra_headers={"X-API-Key": "test"})
    assert(resp.status_code == 200), f"Expected valid token that already registered when X-API-Key does not match {resp.status_code} - {resp.text}"
    
    # X-API-Key does match the expected, nonce validation is skipped
    nonce = int((datetime.now(timezone.utc) - timedelta(days=30)).timestamp())  
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token(nonce=nonce)
    resp = get(lookup=None, token=token, extra_headers={"X-API-Key": "123"})
    assert(resp.status_code == 200), f"Expected valid token that already registered when X-API-Key does match, nonce validation is skipped: {resp.status_code} - {resp.text}"
    