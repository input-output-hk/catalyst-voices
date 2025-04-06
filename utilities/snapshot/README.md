# Snapshot tool

### Generate gateway snapshot
```sh
export BEARER_TOKEN="Bearer catv1.UJm5ZNT1n7l3_h3c3VXp1R9QAZStRmrxdtYwTrdsxKWIF1hAi3mqbz6dPNiICQCkoXWJs8KCpcaPuE7LE5Iu9su0ZweK_0Qr9KhBNNHrDMCh79-fruK7WyNPYNc6FrjwTPaIAQ"

export HOST="http://gateway.dev.projectcatalyst.io/"

export API_KEY="vtovmaqhretrsracdsoqwrisu"

python3 snapshot.py --slot-no 146620747 --page-limit 200000 --bearer-token "$BEARER_TOKEN" --host "$HOST" --api-key "$API_KEY" 
```