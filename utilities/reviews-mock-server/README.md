# Reviews Mock Server

Mock server for the Catalyst Reviews API using Prism and Express.

## Architecture

The mock server consists of two layers:

* **Prism** (port 4010) - Generates mock responses from the OpenAPI specification
* **Express** (port 4020) - Entry point that intercepts specific endpoints for custom logic, proxies everything else to Prism

## Prerequisites

* Node.js 18+
* npm

## Local Development

Install dependencies:

```sh
npm install
```

Start the server:

```sh
npm run dev
```

This runs both Prism and Express concurrently.
Uses the OpenAPI spec from `catalyst_voices/packages/internal/catalyst_voices_repositories/openapi/cat-reviews.json`.

## OpenAPI Spec

The `cat-reviews.json` file in this directory is a copy of the canonical spec for Docker builds.
If the API changes, update the canonical file and copy it here:

```sh
cp ../../catalyst_voices/packages/internal/catalyst_voices_repositories/openapi/cat-reviews.json .
```

## Docker

Build the image using Earthly:

```sh
earthly +docker
```

Run the container:

```sh
docker run -p 4020:4020 reviews-mock-server:latest
```

## Endpoint Overrides

The following endpoints have custom mock implementations instead of Prism-generated responses:

### POST `/api/catalyst-ids/me`

Registers a Catalyst ID.
Caches the data for subsequent GET requests.

**Request:**

```json
{
  "email": "user@example.com",
  "catalyst_id_uri": "username@preprod.cardano/publicKey123"
}
```

**Response:**

```json
{
  "_cid": "preprod.cardano/publicKey123",
  "email": "user@example.com",
  "username": "username",
  "status": 0,
  "rbac_reg_status": 1
}
```

### GET `/api/catalyst-ids/me`

Retrieves the cached Catalyst ID data.
Extracts `_cid` from the Authorization header.

**Authorization header format:**

```text
Bearer catid.:<timestamp>@<network>.<chain>/<publicKey>.<signature>
```

**Response:** Returns cached data from prior POST, or default mock data if no cache exists.

## Integration with E2E Tests

The mock server is included in the E2E test infrastructure via `docker-compose.yml`.
Nginx routes `/api/reviews/*` requests to this mock server, rewriting paths:

```text
/api/reviews/catalyst-ids/me  →  /api/catalyst-ids/me
```

## Adding New Overrides

To override additional endpoints, add route handlers in `server.js` before the Prism proxy middleware:

```javascript
app.get("/api/your-endpoint", (req, res) => {
  // Custom logic
  return res.status(200).json({ ... });
});
```
