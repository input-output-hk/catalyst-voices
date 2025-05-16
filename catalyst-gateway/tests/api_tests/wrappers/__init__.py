# Proxy wrapper used for integration testing
import asyncio
import signal
import subprocess
import time

class TestProxy:
    """Proxy wrapper used for integration testing."""

    # Skip pytest collection
    __test__ = False

    proxy_name: str
    proxy_port: int
    db_port: int
    process: subprocess.Popen | None = None

    def __init__(self, proxy_name:str, proxy_port: int, db_port: int):
        """Initialize Test Proxy"""
        self.proxy_name = proxy_name
        self.proxy_port = proxy_port
        self.db_port = db_port
        print(f"{proxy_name} Proxy at port {proxy_port}!")

    def start(self):
        """Start the Test Proxy"""
        if self.process:
            print("The process is already running. Stop it first.")
        else:
            cmd = ["mitmdump", "--listen-port", f"{self.proxy_port}", "--tcp-hosts", "127.0.0.1", "--mode", f"reverse:tcp://localhost:{self.db_port}"]
            p = subprocess.Popen(cmd, stdout=subprocess.DEVNULL)
            self.process = p
            print(f"Running {self.proxy_name} Proxy!")

    def has_started(self) -> bool:
        return self.process is not None

    def stop(self) -> bool:
        if self.process:
            self.process.kill()
            self.process = None
            stopped = True
            print(f"Stopped {self.proxy_name} Proxy!")
        else:
            print("The process must be running for it to be stopped.")
            stopped = False
        return stopped

    def resume(self):
        if self.process:
            print(f"Resuming {self.proxy_name}")
            self.process.send_signal(signal.SIGCONT)
        else:
            print("No process to resume.")

    def suspend(self):
        if self.process:
            print(f"Suspending {self.proxy_name}")
            self.process.send_signal(signal.SIGSTOP)
        else:
            print("No process to suspend.")

async def run_test_proxy(name: str, port: int, db_port: int):
    p = TestProxy(name, port, db_port)
    p.start()
    print(f"> {p.proxy_name} started at {time.strftime('%X')}")
    #print("Waiting 10 seconds")
    #await asyncio.sleep(10.0)
    #print(f"> {p.name} finished at {time.strftime('%X')}")
    #p.stop()


async def run_proxies():

    async with asyncio.TaskGroup() as tg:
        task1 = tg.create_task(run_test_proxy("Event DB", 18080, 5432))
        task2 = tg.create_task(run_test_proxy("Index DB", 18090, 9042))

        print(f"started at {time.strftime('%X')}")
        await task1
        await task2
        print(f"finished at {time.strftime('%X')}")


if __name__ == "__main__":
    print("Running Proxy!")
    asyncio.run(run_proxies())
