// Integration test example
//

// TODO - move this integration test into other place,
//        so it will not execute during common Rust test procedure.
#[tokio::test]
#[ignore]
async fn health_live() {
    let cat_gateway_address = "http://127.0.0.1:3030";
    let client = reqwest::Client::new();
    let url = format!("{cat_gateway_address}/api/health/live");
    let response = client
        .get(&url)
        .send()
        .await
        .expect("Failed to execute request to {url}.");

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
