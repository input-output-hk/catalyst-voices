use poem::{Body, FromRequest, IntoResponse, Request, RequestBody, Response, Result};
use poem_openapi::{
    impl_apirequest_for_payload,
    payload::{ParsePayload, Payload},
    registry::{MetaMediaType, MetaResponse, MetaResponses, MetaSchema, MetaSchemaRef, Registry},
    ApiResponse,
};

/// A cbor binary payload.
///
/// # Examples
///
/// ```rust
/// use poem::{
///     error::BadRequest,
///     http::{Method, StatusCode, Uri},
///     test::TestClient,
///     Body, IntoEndpoint, Request, Result,
/// };
/// use poem_openapi::{
///     payload::{Cbor, Json},
///     OpenApi, OpenApiService,
/// };
/// use tokio::io::AsyncReadExt;
///
/// struct MyApi;
///
/// #[OpenApi]
/// impl MyApi {
///     #[oai(path = "/upload", method = "post")]
///     async fn upload_binary(&self, data: Cbor<Vec<u8>>) -> Json<usize> {
///         Json(data.len())
///     }
///
///     #[oai(path = "/upload_stream", method = "post")]
///     async fn upload_binary_stream(&self, data: Cbor<Body>) -> Result<Json<usize>> {
///         let mut reader = data.0.into_async_read();
///         let mut bytes = Vec::new();
///         reader.read_to_end(&mut bytes).await.map_err(BadRequest)?;
///         Ok(Json(bytes.len()))
///     }
/// }
///
/// let api = OpenApiService::new(MyApi, "Demo", "0.1.0");
/// let cli = TestClient::new(api);
///
/// # tokio::runtime::Runtime::new().unwrap().block_on(async {
/// let resp = cli
///     .post("/upload")
///     .content_type("application/octet-stream")
///     .body("abcdef")
///     .send()
///     .await;
/// resp.assert_status_is_ok();
/// resp.assert_text("6").await;
///
/// let resp = cli
///     .post("/upload_stream")
///     .content_type("application/octet-stream")
///     .body("abcdef")
///     .send()
///     .await;
/// resp.assert_status_is_ok();
/// resp.assert_text("6").await;
/// # });
/// ```
#[derive(Debug)]
pub struct Cbor(Body);

impl From<Vec<u8>> for Cbor {
    fn from(value: Vec<u8>) -> Self {
        Self(value.into())
    }
}

impl Cbor {
    /// Returns an inner bytes with the limit
    pub(crate) async fn into_bytes_with_limit(
        self, limit: usize,
    ) -> Result<Vec<u8>, poem::error::ReadBodyError> {
        Ok(self.0.into_bytes_limit(limit).await?.to_vec())
    }
}

impl Payload for Cbor {
    const CONTENT_TYPE: &'static str = "application/cbor";

    fn check_content_type(content_type: &str) -> bool {
        matches!(content_type.parse::<mime::Mime>(), Ok(content_type) if content_type.type_() == "application"
                && (content_type.subtype() == "cbor"
                || content_type
                    .suffix()
                    .is_some_and(|v| v == "cbor")))
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema {
            format: Some("binary"),
            ..MetaSchema::new("string")
        }))
    }
}

impl ParsePayload for Cbor {
    const IS_REQUIRED: bool = true;

    async fn from_request(request: &Request, body: &mut RequestBody) -> Result<Self> {
        Ok(Self(Body::from_request(request, body).await?))
    }
}

impl IntoResponse for Cbor {
    fn into_response(self) -> Response {
        Response::builder()
            .content_type(Self::CONTENT_TYPE)
            .body(self.0)
    }
}

impl ApiResponse for Cbor {
    fn meta() -> MetaResponses {
        MetaResponses {
            responses: vec![MetaResponse {
                description: "",
                status: Some(200),
                content: vec![MetaMediaType {
                    content_type: Self::CONTENT_TYPE,
                    schema: Self::schema_ref(),
                }],
                headers: vec![],
            }],
        }
    }

    fn register(_registry: &mut Registry) {}
}

impl_apirequest_for_payload!(Cbor);
