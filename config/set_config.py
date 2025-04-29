"""
A script for inserting frontend config files via the `config/frontend` PUT endpoint.

# Example

```py
python3 config/set_config.py --retry dev
```

Will try and set the config for the dev environment
by reading all the settings and the configs from the `<repo root>/config/dev/` directory.

The tool will find the endpoint, and any other config it needs to operate from the `settings.json` file.
It will apply `config.json` as the default config, and if any `ip_xxx.xxx.xxx.xxx.config.json` files exist,
will also set the IP address specific configs as defined by their file name.
"""

import argparse
import json
import os
import glob
import time
import requests
import re


# helpers
def load_json_file(filepath: str):
    with open(filepath, "r") as f:
        return json.load(f)


def deep_merge(a: dict, b: dict) -> dict:
    result = a.copy()
    for key, value in b.items():
        if key in result:
            if isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = deep_merge(result[key], value)
            elif isinstance(result[key], list) and isinstance(value, list):
                result[key] = result[key] + value
            else:
                result[key] = value
        else:
            result[key] = value
    return result


def parse_ip_config_file(path: str) -> tuple[str, dict]:
    filename = os.path.basename(path)
    match = re.match(r"ip_(\d{1,3}(?:\.\d{1,3}){3})\.config\.json", filename)
    if not match:
        raise ValueError(f"Invalid IP config filename: {filename}")

    ip = match.group(1)

    return ip, load_json_file(path)


# main action
def set_config(env: str):
    repo_root = os.path.dirname(os.path.abspath(__file__))
    env_dir = os.path.join(repo_root, env)

    print(f"Setting config for environment: {env}")
    print(f"Looking for configs in: {env_dir}")

    # load settings.json
    settings_path = os.path.join(env_dir, "settings.json")
    if not os.path.isfile(settings_path):
        raise FileNotFoundError(f"Missing settings.json at {settings_path}")
    settings = load_json_file(settings_path)
    print(f"Loaded settings:\n{settings}")

    # load and apply config.json
    config_path = os.path.join(env_dir, "config.json")
    if not os.path.isfile(config_path):
        raise FileNotFoundError(f"Missing config.json at {config_path}")
    config = load_json_file(config_path)
    print(f"Applying default config:\n{config}")

    # find and apply any ip-specific configs
    ip_config_paths = glob.glob(os.path.join(env_dir, "ip_*.config.json"))
    for ip_config_path in ip_config_paths:
        ip, ip_config = parse_ip_config_file(ip_config_path)
        print(
            f"Applying IP-specific config from {os.path.basename(ip_config_path)}:\n{ip_config}"
        )

        payload = deep_merge(config, ip_config)

        requests.put(f"https://{ip}/api/draft/config/frontend", json=payload)


# args parser
def main():
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
        except Exception as e:
            print(f"Error: {e}")
            if args.retry:
                print("Retrying in 1 minute...")
                time.sleep(60)
            else:
                break


if __name__ == "__main__":
    main()
