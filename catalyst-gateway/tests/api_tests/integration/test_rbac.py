import pytest
from utils.rbac_chain import ONLY_ROLE_0_REG_JSON, rbac_chain_factory, RoleID
from api.v1.rbac import get

@pytest.mark.preprod_indexing
def test_rbac_endpoints(rbac_chain_factory):
    
    auth_token = rbac_chain_factory(RoleID.ROLE_0).auth_token()
    
    # Registered stake address lookup
    stake_address = ONLY_ROLE_0_REG_JSON["0"][0]["stake_address"]
    resp = get(lookup=stake_address, token=auth_token)
    assert(resp.status_code == 200), f"Expected registered stake address: {resp.status_code} - {resp.text}"

    # Not registered stake address lookup
    # Cardano test data CIP0019
    # <https://github.com/cardano-foundation/CIPs/blob/master/CIP-0019/README.md>
    # cspell:disable-next-line
    stake_address = "stake_test17rphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcljw6kf"
    resp = get(lookup=stake_address, token=auth_token)
    assert(resp.status_code == 404), f"Expected not registered stake address: {resp.status_code} - {resp.text}"

    # Wrong format stake address lookup
    stake_address = "stake_invalid_address"
    resp = get(lookup=stake_address, token=auth_token)
    assert(resp.status_code == 412), f"Expected wrong format stake address: {resp.status_code} - {resp.text}"
    
    # Registered Catalyst ID lookup
    cat_id = rbac_chain_factory(RoleID.ROLE_0).cat_id_for_role(RoleID.ROLE_0)[0]
    resp = get(lookup=cat_id, token=auth_token)
    assert(resp.status_code == 200), f"Expected registered cat id: {resp.status_code} - {resp.text}"

    cat_id = rbac_chain_factory(RoleID.ROLE_0).short_cat_id()
    resp = get(lookup=cat_id, token=auth_token)
    assert(resp.status_code == 200), f"Expected registered short cat id: {resp.status_code} - {resp.text}"
    
    # Not registered Catalyst ID lookup
    # <https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/rbac_id_uri/catalyst-id-uri/#test-vectors>
    # cspell:disable-next-line
    cat_id = "preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
    resp = get(lookup=cat_id, token=auth_token)
    assert(resp.status_code == 404), f"Expected not registered cat id: {resp.status_code} - {resp.text}"
        
    # Wrong format Catalyst ID lookup
    # cspell:disable-next-line
    cat_id = "invalidFftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE"
    resp = get(lookup="cat_id", token=auth_token)
    assert(resp.status_code == 412), f"Expected wrong format cat id: {resp.status_code} - {resp.text}"
