# Proxy wrapper used for integration testing
import subprocess
from loguru import logger

class TestProxy:
    def __init__(self, container_name, backend, server):
        self.container_name = container_name
        self.backend = backend
        self.server = server

    def _exec_haproxy_cmd(self, haproxy_cmd):
        """Run a command inside the HAProxy container."""
        cmd = [
            "docker", "exec", self.container_name,
            "sh", "-c", f"echo \"{haproxy_cmd}\" | socat /var/run/haproxy/haproxy.sock stdio"
        ]
        subprocess.run(cmd, check=True)

    def enable(self):
        self._exec_haproxy_cmd(f"enable server {self.backend}/{self.server}")
        assert self.is_running()
        logger.info(f"Enabled {self.backend}/{self.server} on {self.container_name}")

    def disable(self):
        self._exec_haproxy_cmd(f"disable server {self.backend}/{self.server}")
        assert not self.is_running()
        logger.info(f"Disabled {self.backend}/{self.server} on {self.container_name}")

    def is_running(self):
        """Check if server is operational (OpState=2, AdminState=0)."""
        check_cmd = (
            f"echo \"show servers state\" | socat /var/run/haproxy/haproxy.sock stdio | "
            f"awk -v be=\"{self.backend}\" -v srv=\"{self.server}\" "
            f"'$2==be {{print $6}}'"
        )
        cmd = [
            "docker", "exec", self.container_name,
            "sh", "-c", check_cmd
        ]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        op_state = result.stdout.strip()
        return op_state == "2"
