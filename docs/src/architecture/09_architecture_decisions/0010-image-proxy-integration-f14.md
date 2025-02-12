---
    title: Image Proxy Integration for F14
    adr:
        author: Sasha Prokhorenko
        created: 11-Feb-2025
        status: proposed
    tags:
        - api
        - flutter
---

## Context

Our Flutter web application embeds images from external sources in a rich text editor,
but browser `CORS` restrictions block direct loading of these images.
To fix this, we need an image proxy served through our Poem-based API.

## Assumptions

* **Backend Integration**: The image proxy will be part of our existing
Poem-based API for unified deployment and centralized monitoring.
* **URL Validation**: Input URLs will be strictly validated and sanitized.
* **Performance**: We will use caching and streaming to optimize performance.
* **Security**: We will introduce rate limiting and logging to prevent misuse.

## Decision

We will add a dedicated `/imageProxy` endpoint within our Poem API that:

1. **Accepts** an external image URL via a query parameter (`url`).
2. **Validates** the URL to ensure it starts with `http://` or `https://`.
3. **Fetches** the remote image and streams it to the client.
4. **Sets** the appropriate CORS and content headers to bypass restrictions.
5. **Integrates** with our existing Poem routes, so the Flutter app can request images seamlessly.

## Implementation Guidelines

### Example: Poem Endpoint

Below is a simplified snippet showing how `/imageProxy` might be implemented with Poem.
Replace any mock data or placeholders (e.g., `response_bytes`) with actual logic,
such as fetching the image from an external server or a cache.

```rust
use poem::{
    handler,
    http::{HeaderMap, StatusCode},
    web::Query,
    IntoResponse, Result, Route,
};
use serde::Deserialize;
use url::Url;

#[derive(Deserialize)]
struct ImageProxyQuery {
    url: String,
}

// Cache successful image fetches for 1 hour
#[cached(
    time = 3600,
    result = true,
    key = "String",
    convert = r#"{ format!("{}", url) }"#
)]
async fn fetch_and_cache_image(url: &str) -> Result<Bytes> {
    let client = Client::default();

    let response = client
        .get(url)
        .send()
        .await
        .map_err(|_| StatusCode::BAD_GATEWAY)?;

    if !response.status().is_success() {
        return Err(StatusCode::BAD_GATEWAY.into());
    }

    let content_length = response
        .content_length()
        .unwrap_or(0);

    // Enforce size limit (2MB)
    if content_length > 2_000_000 {
        return Err(StatusCode::PAYLOAD_TOO_LARGE.into());
    }

    response
        .bytes()
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR.into())
}

#[handler]
async fn image_proxy(Query(params): Query<ImageProxyQuery>) -> Result<impl IntoResponse> {
    // Validate the URL format
    let parsed_url = Url::parse(&params.url)
        .map_err(|_| StatusCode::BAD_REQUEST)?;

    if !(parsed_url.scheme() == "http" || parsed_url.scheme() == "https") {
        return Err(StatusCode::BAD_REQUEST.into());
    }

    // Fetch and cache the image
    let image_data = fetch_and_cache_image(&params.url).await?;

    // Determine content type from response
    let content_type = mime_guess::from_path(&parsed_url.path())
        .first_or_octet_stream()
        .to_string();

    // Set response headers
    let mut headers = HeaderMap::new();
    headers.insert("Content-Type", content_type.parse().unwrap());
    headers.insert("Access-Control-Allow-Origin", "*".parse().unwrap());
    headers.insert("Cache-Control", "public, max-age=3600".parse().unwrap());

    Ok((headers, image_data))
}

pub fn create_app() -> Route {
    Route::new().at("/imageProxy", image_proxy)
}
```
### Example: Flutter Usage

Our Flutter application will route all external image requests through `/imageProxy`.
Here’s how:

**Helper Function:**

```dart
String getProxiedUrl(String originalUrl) {
  return 'https://example.com/imageProxy?url=' + Uri.encodeComponent(originalUrl);
}
```

**Usage in Flutter:**

```dart
Image.network(
  getProxiedUrl('https://example.com/path/to/image.png'),
  fit: BoxFit.cover,
);
```

**Rich Text Editor Integration**
If your rich text editor supports custom image handlers or URL interceptors,
configure it to intercept any external image URL and prepend /imageProxy.

By adopting this approach, our Flutter application will use the Poem-based proxy to avoid CORS issues
and centralize image retrieval within our backend.

## Risks

* Performance Overhead: The proxy may become a bottleneck if not optimized or cached properly.
* Security Vulnerabilities: Poor URL validation could allow misuse of the proxy.
* Operational Complexity: Additional proxy logic requires monitoring and logging.
* Rate Limiting: Heavy usage can degrade performance if not properly throttled.

## Consequences

### Positive

* Resolves CORS issues by controlling the response headers.
* Centralizes image handling logic, simplifying Flutter code.
* Integrates cleanly with existing backend infrastructure for logging, monitoring, etc.

### Negative

* Adds an extra network hop, which could impact latency if not well optimized.
* Requires robust caching, rate limiting, and validation to ensure performance and security.

## More Information

* [cached on crates.io](https://docs.rs/cached/latest/cached/)
* Additional Considerations:
  * Investigate caching/CDN strategies if traffic is high.
  * Explore middleware solutions for rate limiting, logging, and more advanced security.

