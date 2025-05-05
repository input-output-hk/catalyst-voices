"""Apply configs to the frontend endpoint."""

import argparse
import ipaddress
import json
import os
import time
from pathlib import Path

import requests


# helpers
def load_json_file(filepath: str) -> dict[str, str]:
    """Read a JSON file from the specified path and return the parsed content."""
    with Path(filepath).open("r") as f:
        return json.load(f)


def parse_ip_config_file(path: Path) -> tuple[str, dict]:
    """Extract and parse IPv4 or IPv6 from the file name, and return the parsed content."""
    filename = path.name
    if not filename.startswith("ip_") or not filename.endswith(".config.json"):
        errmsg = f"Invalid IP config filename: {filename}"
        raise ValueError(errmsg)

    ip_part = filename[len("ip_") : -len(".config.json")]

    ipaddress.ip_address(ip_part)

    return ip_part, load_json_file(path)


def read_config(env_dir: Path) -> tuple[dict[str, str], dict[str, str]]:
    """Extract and prepare configs before applying."""
    # load settings.json
    settings_path = Path(env_dir) / "settings.json"
    if not Path.is_file(settings_path):
        errmsg = f"Missing settings.json at {settings_path}"
        raise FileNotFoundError(errmsg)
    settings = load_json_file(settings_path)
    print(f"Loaded settings:\n{settings}")

    # load config.json
    config_path = Path(env_dir) / "config.json"
    if not Path.is_file(config_path):
        errmsg = f"Missing config.json at {config_path}"
        raise FileNotFoundError(errmsg)
    config = load_json_file(config_path)
    print(f"Applying default config:\n{config}")

    return settings, config


def apply(url: str, api_key: str, config: any, timeout: int, *, ip: str | None = None, retry: bool = False) -> None:
    """Send an HTTP request to apply the config to the specified URL."""
    headers = {"X-API-Key": api_key}

    while True:
        try:
            f_url = url if ip is None else f"{url}?IP={ip}"
            
            resp = requests.put(f_url, json=config, headers=headers, timeout=timeout)
            resp.raise_for_status()
            break
        except requests.exceptions.RequestException as e:
            errmsg = f"failed to send HTTP request: {e}"
            print(errmsg)

            if retry:
                print("Retrying in 1 minute...")
                time.sleep(60)
            else:
                break


# main action
def set_config(env: str, *, retry: bool = False) -> None:
    """Read config files from the specified `env`, then apply the configs."""
    file_dir = Path(__file__).resolve().parent
    env_dir = Path(file_dir) / env

    print(f"Setting config for environment: {env}")
    print(f"Looking for configs in: {env_dir}")

    settings, config = read_config(env_dir)

    url = settings["url"]
    timeout = settings["timeout"]
    api_key_env = settings["api_key_env"]

    api_key = os.environ[api_key_env]

    # apply base config
    apply(url, api_key, config, timeout, retry=retry)

    # find and apply any ip-specific configs
    ip_config_paths = list(env_dir.glob("ip_*.config.json"))
    for ip_config_path in ip_config_paths:
        try:
            ip, ip_config = parse_ip_config_file(ip_config_path)
            print(f"Applying IP-specific config from {ip_config_path.name}:\n{ip_config}")

            apply(url, api_key, ip_config, timeout, ip=ip, retry=retry)
        except ValueError as e:
            errmsg = f"Skipping {ip_config_path.name}, invalid IP address format: {e}"
            print(errmsg)


# args parser
parser = argparse.ArgumentParser(description="Set environment configuration.")
parser.add_argument(
    "--retry",
    action="store_true",
    help="If setting config fails, wait 1 minute and retry indefinitely until successful.",
)
parser.add_argument(
    "env",
    type=str,
    help="The environment to configure (e.g., dev, qa, preprod, prod).",
)

args = parser.parse_args()

set_config(args.env, retry=args.retry)
print(f"Finished applying configuration for '{args.env}'.")
