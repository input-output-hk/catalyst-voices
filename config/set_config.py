"""
A script for inserting frontend config files via the `config/frontend` PUT endpoint.

# Example

```sh
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
import ipaddress


# helpers
def load_json_file(filepath: str):
    with open(filepath, "r") as f:
        return json.load(f)


def parse_ip_config_file(path: str) -> tuple[str, dict]:
    filename = os.path.basename(path)
    if not filename.startswith("ip_") or not filename.endswith(".config.json"):
        raise ValueError(f"Invalid IP config filename: {filename}")

    ip_part = filename[len("ip_") : -len(".config.json")]

    try:
        ipaddress.ip_address(ip_part)
    except ValueError:
        raise ValueError(f"Invalid IP address in filename: {ip_part}")

    return ip_part, load_json_file(path)


def extract_attribute(obj: str, field_name: str):
    if field_name in obj:
        return obj[field_name]
    else:
        raise KeyError(f"Missing required key: '{field_name}'")


# main action
def set_config(env: str):
    file_dir = os.path.dirname(os.path.abspath(__file__))
    env_dir = os.path.join(file_dir, env)

    print(f"Setting config for environment: {env}")
    print(f"Looking for configs in: {env_dir}")

    # load settings.json
    settings_path = os.path.join(env_dir, "settings.json")
    if not os.path.isfile(settings_path):
        raise FileNotFoundError(f"Missing settings.json at {settings_path}")
    settings = load_json_file(settings_path)
    print(f"Loaded settings:\n{settings}")

    # extract settings.json attributes
    url = extract_attribute(settings, "url")
    api_key = extract_attribute(settings, "api_key")
    headers = {"X-API-Key": api_key}

    # load and apply config.json
    config_path = os.path.join(env_dir, "config.json")
    if not os.path.isfile(config_path):
        raise FileNotFoundError(f"Missing config.json at {config_path}")
    config = load_json_file(config_path)
    print(f"Applying default config:\n{config}")

    try:
        resp = requests.put(url, json=config, headers=headers)
        resp.raise_for_status()
    except Exception as e:
        print(f"Skipping {os.path.basename(config_path)} due to error: {e}")

    # find and apply any ip-specific configs
    ip_config_paths = glob.glob(os.path.join(env_dir, "ip_*.config.json"))
    for ip_config_path in ip_config_paths:
        basename = os.path.basename(ip_config_path)

        try:
            ip, ip_config = parse_ip_config_file(ip_config_path)
            print(f"Applying IP-specific config from {basename}:\n{ip_config}")

            resp = requests.put(f"{url}?IP={ip}", json=ip_config, headers=headers)
            resp.raise_for_status()
        except requests.exceptions.RequestException as e:
            print(f"Skipping {basename}, failed to send HTTP request: {e}")
        except ValueError as e:
            print(f"Skipping {basename}, invalid IP address format: {e}")
        except Exception as e:
            print(f"Skipping {basename} due to error: {e}")


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
        except requests.exceptions.RequestException as e:
            print(f"HTTP request failed: {e}")
        except FileNotFoundError as e:
            print(f"Missing file: {e}")
        except KeyError as e:
            print(f"Config error: {e}")
        except ValueError as e:
            print(f"Validation error: {e}")
        except Exception as e:
            print(f"Unexpected error: {e}")

        if args.retry:
            print("Retrying in 1 minute...")
            time.sleep(60)
        else:
            print("Failed to set configuration. Exiting.")
            exit(1)


if __name__ == "__main__":
    main()
