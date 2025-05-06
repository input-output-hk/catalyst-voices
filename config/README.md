# A script for inserting frontend config files

A script for inserting frontend config files via the `config/frontend` PUT endpoint.

## Example

```sh
python3 config/set_config.py --retry dev
```

Will try and set the config for the dev environment
by reading all the settings and the configs from the `<repo root>/config/dev/` directory.

The tool will find the endpoint, and any other config it needs to operate from the `settings.json` file.
It will apply `config.json` as the default config, and if any `ip_xxx.xxx.xxx.xxx.config.json` files exist,
will also set the IP address specific configs as defined by their file name.
