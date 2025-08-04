# Config Importer

> A script for inserting frontend config files via the `config/frontend` PUT endpoint.

## Usage

```sh
uv run python set_config.py <env>
```

You will need to ensure that the `API_KEY` environment variable is set to the correct value configured in Gateway.
You can copy the `.env.example` to `.env` and replace the key accordingly.

## Example

```sh
uv run python set_config.py --retry dev
```

Will try and set the config for the dev environment by reading all the settings and the configs from the `<repo root>/config/dev/`
directory.

The tool will find the endpoint, and any other config it needs to operate from the `settings.json` file.
It will apply `config.json` as the default config, and if any `ip_xxx.xxx.xxx.xxx.config.json` files exist, will also set the IP
address specific configs as defined by their file name.
