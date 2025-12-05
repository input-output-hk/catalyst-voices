# Catalyst Signed Documents importer scripts

> A collection of scripts for inserting ["Catalyst Signed Documents"]
like `Proposal`, `Comment`, `Proposal Form Template`, etc. via the `v1/document` PUT endpoint.

## Setup fund

The tool will find the endpoint, and any other configuration
it needs to operate from the corresponding `settings.json` file to the provided `<env>`.

```sh
uv run setup_fund.py <env>
```

You will need to ensure that the `MK_SIGNED_DOC_PATH` environment variable is set to the correct path to the
[`mk_signed_doc` cli tool](https://github.com/input-output-hk/catalyst-libs/tree/main/rust/signed_doc/bins)
and also that it is set environment variable from the `settings.json` `admin_private_key_env` property.

["Catalyst Signed Documents"]: https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/spec/