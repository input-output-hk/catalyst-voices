//! These endpoints are not part of the API, and are for testing features of
//! Poem before integration with the real API endpoints.

mod test_get;
mod test_post;

use std::sync::Arc;

use poem::web::Data;
use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};

use crate::{
    service::{
        common::tags::ApiTags, utilities::middleware::schema_validation::schema_version_validation,
    },
    state::State,
};

/// Test API Endpoints
pub(crate) struct TestApi;

#[OpenApi(prefix_path = "/test", tag = "ApiTags::Test")]
impl TestApi {
    #[oai(
        path = "/test/:id/test/:action",
        method = "get",
        operation_id = "testGet",
        transform = "schema_version_validation",
        deprecated
    )]
    /// Test Get API
    ///
    /// An Endpoint to test validation of get endpoints.
    ///
    /// ## Note
    ///
    /// *This is not a real endpoint, for test and demo purposes only.  To be removed.*
    async fn test_get(
        &self,
        /// Get the state, not part of the path, but supplied by Poem.
        data: Data<&Arc<State>>,
        #[oai(validator(
            multiple_of = "5",
            minimum(value = "5"),
            maximum(value = "21", exclusive)
        ))]
        /// The ID of the test.
        ///
        /// This comment ends up in the documentation.
        ///
        /// * 5 will print an info log
        /// * 10 will print a warn log
        /// * 15 will print a error log
        /// * 20 will panic which should generate a 500
        id: Path<i32>,
        #[oai(validator(
            pattern = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
            max_length = "36"
        ))]
        /// The action just needs to be any valid UUID.
        ///
        /// # Make sure its a UUID
        action: Path<String>,
        #[oai(validator(min_items = 0, max_items = 3, unique_items))]
        /// List your favorite pets, in order of preference
        pet: Query<Option<Vec<test_get::Animals>>>,
    ) -> test_get::AllResponses {
        test_get::endpoint(data.clone(), *id, &action, &pet).await
    }

    #[oai(
        path = "/test/:id/test/:action",
        method = "post",
        operation_id = "testPost",
        tag = "ApiTags::TestTag2",
        deprecated
    )]
    /// Test Post API
    ///
    /// An Endpoint to test validation of get endpoints.
    ///
    /// ## Responses
    ///
    /// * 204 No Content - Service is Started and can serve requests.
    /// * 500 Server Error - If anything within this function fails unexpectedly.
    /// * 503 Service Unavailable - Service has not started, do not send other requests
    ///   yet.
    ///
    /// ## Note
    ///
    /// *This is not a real endpoint, for test and demo purposes only.  To be removed.*
    async fn test_post(
        &self,
        #[oai(validator(
            multiple_of = "5",
            minimum(value = "5"),
            maximum(value = "21", exclusive)
        ))]
        /// The ID of the test.
        ///
        /// * 5 will print an info log
        /// * 10 will print a warn log
        /// * 15 will print a error log
        /// * 20 will panic which should generate a 500
        id: Path<i32>,
        #[oai(validator(
            pattern = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
            max_length = "36",
            min_length = "36"
        ))]
        /// The action just needs to be any valid UUID.
        ///
        /// # Make sure its a UUID
        action: Path<String>,
    ) -> test_post::AllResponses {
        test_post::endpoint(*id, &action).await
    }
}
