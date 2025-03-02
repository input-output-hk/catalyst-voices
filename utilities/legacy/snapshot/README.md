# Snapshot tool

### Generate gateway snapshot
```sh
export BEARER_TOKEN="Bearer catv1.UJm5ZNT1n7l3_h3c3VXp1R9QAZStRmrxdtYwTrdsxKWIF1hAi3mqbz6dPNiICQCkoXWJs8KCpcaPuE7LE5Iu9su0ZweK_0Qr9KhBNNHrDMCh79-fruK7WyNPYNc6FrjwTPaIAQ"

export HOST="http://gateway.dev.projectcatalyst.io/"

export API_KEY="vtov............"

python3 snapshot.py snapshot --slot-no 146620747 --bearer-token "$BEARER_TOKEN" --host "$HOST" --api-key "$API_KEY" 
```

### Compare legacy snapshot with gateway snapshot
```sh
export GATEWAY_SNAPSHOT=snapshot.json

export LEGACY_SNAPSHOT=../catalyst-core/src/voting-tools-rs/cexplorer-146620747.json

python3 snapshot.py compare --legacy-snapshot $LEGACY_SNAPSHOT --gateway-snapshot $GATEWAY_SNAPSHOT
```

### Code quality

Code should be validated with `ruff`.
`pyproject.toml` defines the rules that are enforced.
The aim should be for everything to be properly type annotated.
However, if a type can not be annotated, or is detected wrong the lint error
should be suppressed.

Check code before check-in with:

```sh
ruff check . --preview
```

The only errors that will be accepted are `FIX002` do not disable these errors
as they are intended to guide outstanding work and should only be removed when
the issues they link to are completed.

The following command will autofix any lint errors which can be corrected.
Most notably imports will be properly sorted.

```sh
ruff check . --preview --fix
```

Linting will enforce comments in the code, these are not optional,
do not suppress them.

Code should be properly formatted with `black`.

Check that with:

```sh
black --check .
```

`black` can fix your formatting:

```sh
black .
```