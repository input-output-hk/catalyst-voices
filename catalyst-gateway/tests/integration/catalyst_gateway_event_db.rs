// Integration test example
//
#[tokio::test]
async fn health_live() {
    let cat_gateway_address = "http://127.0.0.1:3030";
    let client = reqwest::Client::new();
    let url = format!("{cat_gateway_address}/api/health/live");

    let response = client.get(&url).send().await;

    match response {
        Ok(res) => {
            assert_eq!(
                res.status().as_u16(),
                204,
                "request failed for {url} response: {res:#?}"
            );
            assert_eq!(
                Some(0),
                res.content_length(),
                "request failed for {url} response: {res:#?}"
            );
        },
        Err(err) => {
            eprint!("request failed for {url} error: {err:#?}")
        },
    }
}
