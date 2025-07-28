import pytest


# marks all not marked tests with the `unmarked` mark so it will possible to run
# `pytest -m "unmarked"` to run all unmarked tests
def pytest_collection_modifyitems(items, config):
    for item in items:
        if not any(item.iter_markers()):
            item.add_marker("unmarked")
