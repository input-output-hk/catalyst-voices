import pytest
from api.v1 import config_frontend


# TODO: missing test case with putting frontend config to the specific IP address
def test_config_frontend():
    exp_config = {"some": "thing"}
    resp = config_frontend.put(exp_config)
    assert (
        resp.status_code == 204
    ), f"Failed to publish frontend config: {resp.status_code} - {resp.text}"

    resp = config_frontend.get()
    assert (
        resp.status_code == 200
    ), f"Failed to get published frontend config: {resp.status_code} - {resp.text}"
    config = resp.json()
    assert (
        config == exp_config
    ), f"Loaded config does not match with the expected: epx {exp_config}, loaded: {config}"

    exp_config2 = {"some": "other thing"}
    resp = config_frontend.put(exp_config2)
    assert (
        resp.status_code == 204
    ), f"Failed to publish frontend config: {resp.status_code} - {resp.text}"

    resp = config_frontend.get()
    assert (
        resp.status_code == 200
    ), f"Failed to get published frontend config: {resp.status_code} - {resp.text}"
    config = resp.json()
    assert (
        config != exp_config
    ), f"Loaded config should not match with the previous: previous {exp_config}, loaded: {config}"
    assert (
        config == exp_config2
    ), f"Loaded config does not match with the expected: epx {exp_config2}, loaded: {config}"
