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


# main action
def set_config(env: str) -> None:
    """Read config files from the specified `env`, then apply the configs."""
    file_dir = Path(__file__).resolve().parent
    env_dir = Path(file_dir) / env

    print(f"Setting config for environment: {env}")
    print(f"Looking for configs in: {env_dir}")

    # load settings.json
    settings_path = Path(env_dir) / "settings.json"
    if not Path.is_file(settings_path):
        errmsg = f"Missing settings.json at {settings_path}"
        raise FileNotFoundError(errmsg)
    settings = load_json_file(settings_path)
    print(f"Loaded settings:\n{settings}")

    # extract settings.json attributes
    url = settings["url"]
    timeout = settings["timeout"]
    api_key_env = settings["api_key_env"]

    api_key = os.environ[api_key_env]

    headers = {"X-API-Key": api_key}

    # load and apply config.json
    config_path = Path(env_dir) / "config.json"
    if not Path.is_file(config_path):
        errmsg = f"Missing config.json at {config_path}"
        raise FileNotFoundError(errmsg)
    config = load_json_file(config_path)
    print(f"Applying default config:\n{config}")

    try:
        resp = requests.put(url, json=config, headers=headers, timeout=timeout)
        resp.raise_for_status()
    except requests.exceptions.RequestException as e:
        errmsg = f"Skipping {config_path.name}, failed to send HTTP request: {e}"
        print(errmsg)

    # find and apply any ip-specific configs
    ip_config_paths = list(env_dir.glob("ip_*.config.json"))
    for ip_config_path in ip_config_paths:
        filename = ip_config_path.name

        try:
            ip, ip_config = parse_ip_config_file(ip_config_path)
            print(f"Applying IP-specific config from {filename}:\n{ip_config}")

            resp = requests.put(
                f"{url}?IP={ip}", json=ip_config, headers=headers, timeout=timeout
            )
            resp.raise_for_status()
        except requests.exceptions.RequestException as e:
            errmsg = f"Skipping {filename}, failed to send HTTP request: {e}"
            print(errmsg)
        except ValueError as e:
            errmsg = f"Skipping {filename}, invalid IP address format: {e}"
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

while True:
    try:
        set_config(args.env)
        print(f"Configuration for '{args.env}' set successfully.")
        break
    except FileNotFoundError as e:
        errmsg = f"Missing file: {e}"
        print(errmsg)
    except KeyError as e:
        errmsg = f"Missing config or env variable: {e}"
        print(errmsg)

    if args.retry:
        print("Retrying in 1 minute...")
        time.sleep(60)
    else:
        print("Failed to set configuration.")
        break
