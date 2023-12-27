// cspell: words reqwest
// Integration test example
//
#[tokio::test]
async fn health_live() {
    let cat_gateway_address = "http://127.0.0.1:3030";
    let client = reqwest::Client::new();
    let url = format!("{cat_gateway_address}/api/health/live");

    let response = unwrap!(
        client.get(&url).send().await,
        "Failed to execute request to {url}."
    );
    assert_eq!(
        response.status().as_u16(),
        204,
        "request failed for {url} response: {response:#?}"
    );
    assert_eq!(
        Some(0),
        response.content_length(),
        "request failed for {url} response: {response:#?}"
    );
}
