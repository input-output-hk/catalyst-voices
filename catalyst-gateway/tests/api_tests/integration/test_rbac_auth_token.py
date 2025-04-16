import requests
from api import cat_gateway_endpoint_url
from utils import health, sync
from utils.rbac_chain import rbac_chain_factory, RoleID, RBACChain
from datetime import datetime, timezone

URL = cat_gateway_endpoint_url("api/v1/rbac/registration")

def get(lookup: str | None, token: str):
    headers = {
        "Authorization": f"Bearer {token}",
    }
    return requests.get(URL, headers=headers, params={"lookup": lookup})


def test_invalid_rbac_auth_token():
    health.is_live()
    health.is_ready()

    # Token doesn't start with catid. -> 401
    resp = get(lookup=None, token="invalid")
    assert( resp.status_code == 401 ), f"Expected missing token prefix: {resp.status_code} - {resp.text}"

    # Missing signature -> 401
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected missing token signature: {resp.status_code} - {resp.text}"
    
    # Signature invalid length -> 401
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.abcdfg"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected invalid length signature: {resp.status_code} - {resp.text}"
    
    # Signature is not a base64 url, but role 0 pk is in correct format -> 401
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.abcdfg.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x-/VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected invalid signature: {resp.status_code} - {resp.text}"
    
    # Text after `catid.` is not a Catalyst ID -> 401
    token = "catid.:1744185821notacatid.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected invalid Catalyst ID: {resp.status_code} - {resp.text}"

    # Auth token has username -> 401
    token = "catid.alice:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected must not contain username: {resp.status_code} - {resp.text}"
    
    # Catalyst ID not in a correct format -> 401 (having : before preprod)
    token = "catid.id.catalyst://:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected invalid Catalyst ID format: {resp.status_code} - {resp.text}"
    
    # Catalyst ID part doesn't contain nonce -> 401
    token = "catid.@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected nonce: {resp.status_code} - {resp.text}"

    # Catalyst ID part contain role -> 401
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug/0.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected no role: {resp.status_code} - {resp.text}"
    
    # Catalyst ID part contain rotation -> 401
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug/0/0.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected no rotation: {resp.status_code} - {resp.text}"
    
    # Unknown network -> 401
    token = "catid.:1744185821@testnet.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected unknown network: {resp.status_code} - {resp.text}"

    # Role 0 key is not registered in the given network (not found in the database) - 401
    token = "catid.:1744706738@preprod.cardano/bFPjLMdjds6aeHPniAgqtDGyBpfoabj2nPpSQQByrig.mTOqN73XYFiJRqrjkS7zwGFkyS5KHzijGE-xVIllGNDHKYRGfWeu9PIkEVoY0FpqkRbUsRVe755jRcSTsWP2AA"
    resp = get(lookup=None, token=token)
    assert( resp.status_code == 401 ), f"Expected key not registered: {resp.status_code} - {resp.text}"
    
    # Nonce is not in a range -> 403
    token = "catid.:1744185821@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.nEWeRBKoksRSY6W8_Gxeq07I7EiWhm9G-IOGxP7BDFSa-x--VHZPiwji5mWKtZd6qvWSGuOu9TvdklYnGMJ2CQ"
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 403), f"Expected nonce out of range: {resp.status_code} - {resp.text}"

    # Signature verification, not valid signature -> 403. 
    nonce = int(datetime.now(timezone.utc).timestamp())
    token = f"catid.:{nonce}@preprod.cardano/bkL45YmnbrsT7yed94Qe_Ol48Qa-4Zbw48_TR7sxoug.mlMUaAMADHCI59TXwvpe5fnYPLAewKd_71iDr46Qyti7sIYdN-Hyd4dJVfNVDYU4At5XaMniqf5v5wxgmAEOCQ"
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 403), f"Expected invalid signature: {resp.status_code} - {resp.text}"
    
def test_valid_rbac_auth_token(rbac_chain_factory):
    token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    print(token)
    resp = get(lookup=None, token=token)
    assert(resp.status_code == 200), f"Expected valid token that already registered: {resp.status_code} - {resp.text}"
    