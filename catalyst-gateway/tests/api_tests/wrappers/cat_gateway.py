"""Cat Gateway Wrapper"""

import os
import subprocess
import signal
import sys

try:
    CAT_GATEWAY_EXECUTABLE_PATH = os.environ["CAT_GATEWAY_EXECUTABLE_PATH"]
except KeyError:
    print("Please set the environment variable CAT_GATEWAY_EXECUTABLE_PATH")
    sys.exit(1)

class CatGateway:
    """Cat Gateway wrapper used for integration testing."""
    process: subprocess.Popen | None = None

    def init(self):
        print("done")

    def has_started(self) -> bool:
        return self.process is not None

    def start(self):
        """Start the Cat Gateway"""
        if self.process:
            print("The process is already running. Stop it first.")
        else:
            p = subprocess.Popen([CAT_GATEWAY_EXECUTABLE_PATH, "run"]) #, stdout=subprocess.DEVNULL)
            self.process = p
            print("Running Cat Gateway!")

    def stop(self) -> bool:
        if self.process:
            self.process.send_signal(signal.SIGINT)
            self.process = None
            stopped = True
            print("Stopped Cat Gateway!")
        else:
            print("The process must be running for it to be stopped.")
            stopped = False
        return stopped
