# Proxy wrapper used for integration testing
import subprocess
import os
from loguru import logger


def _get_host_env():
    """Return the HAProxy host to use depending on environment."""
    # Check if running inside Docker
    if os.path.exists("/.dockerenv"):
        # inside container: assume container name is reachable via Docker network
        return "haproxy"
    else:
        # running on host: localhost
        return "localhost"


def _exec_haproxy_cmd(haproxy_cmd):
    """Run a HAProxy command"""
    cmd = f'echo "{haproxy_cmd}" | socat tcp:{_get_host_env()}:9999 stdio'
    result = subprocess.run(
        cmd, capture_output=True, text=True, shell=True, check=True, timeout=5
    )
    return result.stdout.strip()


class ProxyHelper:
    def __init__(self, container_name: str, backend: str, server: str):
        self.container_name = container_name
        self.backend = backend
        self.server = server

    def enable(self):
        _exec_haproxy_cmd(f"enable server {self.backend}/{self.server}")
        assert self.is_running()
        logger.info(f"Enabled {self.backend}/{self.server} on {self.container_name}")

    def disable(self):
        _exec_haproxy_cmd(f"disable server {self.backend}/{self.server}")
        assert not self.is_running()
        logger.info(f"Disabled {self.backend}/{self.server} on {self.container_name}")

    def is_running(self):
        """Check if server is operational (state = 2)."""
        result = _exec_haproxy_cmd("show servers state")
        extract_state = (
            f'echo "{result}" | '
            f'awk -v be="{self.backend}" -v srv="{self.server}" '
            f"'$2==be {{print $6}}'"
        )
        result_extract_state = subprocess.run(
            extract_state,
            capture_output=True,
            text=True,
            shell=True,
            check=True,
            timeout=5,
        )
        return result_extract_state.stdout.strip() == "2"
