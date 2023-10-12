use crate::state::State;
use axum::Router;
use std::sync::Arc;

mod fund;

pub fn v0(state: Arc<State>) -> Router {
    let fund = fund::fund(state);

    Router::new().nest("/v0", fund)
}
