# Before running this test, unset RBAC_OFF environment variable

import pytest
import requests
from api import cat_gateway_endpoint_url
from utils import health, sync
from utils.rbac_chain import rbac_chain_factory, RoleID, RBACChain
from datetime import datetime, timezone

URL = cat_gateway_endpoint_url("api/v1/rbac/registration")

def get(lookup: str | None, token: str, extra_headers: dict | None = None):
    headers = {
        "Authorization": f"Bearer {token}",
    }
    if extra_headers:
        headers.update(extra_headers)
    return requests.get(URL, headers=headers, params={"lookup": lookup})

@pytest.mark.skip
def test_invalid_rbac_auth_token():
    health.is_live()
    health.is_ready()

    # Token doesn't start with catid. -> 401
    resp = get(lookup=None, token="invalid")
    assert( resp.status_code == 401 ), f"Expected missing token prefix: {resp.status_code} - {resp.text}"

    # Missing signature (removing all . so cannot split into token and signature) -> 401
    # cspell:disable-next-line 
    token = "catid.:1744185821@preprodcardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected missing token signature: {resp.status_code} - {resp.text}"
    
    # Signature invalid length -> 401
    # cspell:disable-next-line
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.abcdfg"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected invalid length signature: {resp.status_code} - {resp.text}"
    
    # Signature is not a base64 url, but role 0 pk is in correct format -> 401
    # cspell:disable-next-line
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.abcdfg.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x-/VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected invalid signature: {resp.status_code} - {resp.text}"
    
    # Text after `catid.` is not a Catalyst ID -> 401
    # cspell:disable-next-line
    token = "catid.:1744185821notacatid.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected invalid Catalyst ID: {resp.status_code} - {resp.text}"

    # Auth token has username -> 401
    # cspell:disable-next-line
    token = "catid.bob:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected must not contain username: {resp.status_code} - {resp.text}"
    
    # Catalyst ID not in a correct format -> 401 (having : before preprod)
    # cspell:disable-next-line
    token = "catid.id.catalyst://:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected invalid Catalyst ID format: {resp.status_code} - {resp.text}"
    
    # Catalyst ID part doesn't contain nonce -> 401
    # cspell:disable-next-line
    token = "catid.@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected nonce: {resp.status_code} - {resp.text}"

    # Catalyst ID part contain role -> 401
    # cspell:disable-next-line 
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug/0.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected no role: {resp.status_code} - {resp.text}"
    
    # Catalyst ID part contain rotation -> 401
    # cspell:disable-next-line
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug/0/10.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected no rotation: {resp.status_code} - {resp.text}"
    
    # Unsupported network -> 401
    # cspell:disable-next-line
    token = "catid.:1744185821@testnet.test/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected unsupported network: {resp.status_code} - {resp.text}"

    # Unsupported subnet -> 401
    # cspell:disable-next-line
    token = "catid.:1744185821@testnet.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected unsupported subnet: {resp.status_code} - {resp.text}"

    # Role 0 key is not registered in the given network (not found in the database) - 401
    # cspell:disable-next-line
    token = "catid.:1744706738@preprod.cardano/bFPjLMdjds6aeHPniAgqtDGyBpfoabj2nPpSQQByrig.mTOqN73XYFiJRqrjkS7zwGFkyS5KHzijGE-xVIllGNDHKYRGfWeu9PIkEVoY0FpqkRbUsRVe755jRcSTsWP2AA"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected key not registered: {resp.status_code} - {resp.text}"
    
    # Nonce is not in a range -> 403
    # cspell:disable-next-line
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 403), f"Expected nonce expired: {resp.status_code} - {resp.text}"
    
    # Signature verification, not valid signature -> 403.
    nonce = int(datetime.now(timezone.utc).timestamp())
    # cspell:disable-next-line
    token = f"catid.:{nonce}@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.mlMUaAMADHCI59TXwvpe5fnYPLAewKd_71iDr46Qyti7sIYdN-Hyd4dJVfNVDYU4At5XaMniqf5v5wxgmAEOCQ"
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 403), f"Expected invalid signature: {resp.status_code} - {resp.text}"

@pytest.mark.skip
def test_valid_rbac_auth_token(rbac_chain_factory):
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 200), f"Expected valid token that already registered: {resp.status_code} - {resp.text}"
    
    # X-API-Key does not match as expected value, but still pass because the nonce is valid
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    resp = get(lookup=None, token=token, extra_headers={"X-API-Key": "test"})
    assert(resp.status_code == 200), f"Expected valid token that already registered when X-API-Key does not match {resp.status_code} - {resp.text}"
    
    # X-API-Key does match the expected, nonce validation is skipped
    # cspell:disable-next-line
    token = "catid.:1744185821@preprod.cardano/0KGVpkXVe5-h1RfIb08Mnc-xMZTzSX5VVnPDaHvhrqQ.0GKeMeOJKs5LrnqQEM79GI8jzgw-fXD0p1GaKDMMENwm9EwWjeJXYikhJs3nlI5Uw3GBPSY3sSQOMLJA8X5WCA"
    resp = get(lookup=None, token=token, extra_headers={"X-API-Key": "123"})
    assert(resp.status_code == 200), f"Expected valid token that already registered when X-API-Key does match, nonce validation is skipped: {resp.status_code} - {resp.text}"
    