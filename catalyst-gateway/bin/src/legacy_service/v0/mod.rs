use std::sync::Arc;

use axum::Router;

use crate::state::State;

mod fund;

pub(crate) fn v0(state: Arc<State>) -> Router {
    let fund = fund::fund(state);

    Router::new().nest("/v0", fund)
}
