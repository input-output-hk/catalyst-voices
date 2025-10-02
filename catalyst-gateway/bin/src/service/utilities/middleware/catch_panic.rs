//! A middleware to catch and log panics.

use std::{any::Any, backtrace::Backtrace, cell::RefCell, panic::AssertUnwindSafe};

use futures::FutureExt;
use panic_message::panic_message;
use poem::{
    http::{HeaderMap, Method, StatusCode, Uri},
    Endpoint, IntoResponse, Middleware, Request, Response,
};
use poem_openapi::payload::Json;
use tracing::{debug, error};

use crate::{
    service::{
        common::responses::code_500_internal_server_error::InternalServerError,
        utilities::health::{get_live_counter, inc_live_counter, set_not_live},
    },
    settings::Settings,
};

// Allows us to catch the backtrace so we can include it in logs.
thread_local! {
    static BACKTRACE: RefCell<Option<String>> = const { RefCell::new(None) };
    static LOCATION: RefCell<Option<String>> = const { RefCell::new(None) };
}

/// Sets a custom panic hook to capture the Backtrace and Panic Location for logging
/// purposes. This hook gets called BEFORE we catch it.  So the thread local variables
/// stored here are valid when processing the panic capture.
pub(crate) fn set_panic_hook() {
    std::panic::set_hook(Box::new(|panic_info| {
        // Get the backtrace and format it.
        let raw_trace = Backtrace::force_capture();
        let trace = format!("{raw_trace}");
        BACKTRACE.with(move |b| b.borrow_mut().replace(trace));

        // Get the location and format it.
        let location = match panic_info.location() {
            Some(location) => format!("{location}"),
            None => "Unknown".to_string(),
        };
        LOCATION.with(move |l| l.borrow_mut().replace(location));
    }));
}

/// A middleware for catching and logging panics transforming them to the 500 error
/// response. The panic will not crash the service, but it becomes not live after
/// exceeding the `Settings::service_live_counter_threshold()` value. That should cause
/// Kubernetes to restart the service.
pub struct CatchPanicMiddleware {}

impl CatchPanicMiddleware {
    /// Creates a new middleware instance.
    pub fn new() -> Self {
        Self {}
    }
}

impl<E: Endpoint> Middleware<E> for CatchPanicMiddleware {
    type Output = CatchPanicEndpoint<E>;

    fn transform(
        &self,
        ep: E,
    ) -> Self::Output {
        CatchPanicEndpoint { inner: ep }
    }
}

/// An endpoint for the `CatchPanicMiddleware` middleware.
pub struct CatchPanicEndpoint<E> {
    inner: E,
}

impl<E: Endpoint> Endpoint for CatchPanicEndpoint<E> {
    type Output = Response;

    async fn call(
        &self,
        req: Request,
    ) -> poem::Result<Self::Output> {
        // Preserve all the data that we want to potentially log because a request is consumed.
        let method = req.method().clone();
        let uri = req.uri().clone();
        let headers = req.headers().clone();

        match AssertUnwindSafe(self.inner.call(req)).catch_unwind().await {
            Ok(resp) => resp.map(IntoResponse::into_response),
            Err(err) => Ok(panic_response(&err, &method, &uri, &headers)),
        }
    }
}

fn panic_response(
    err: &Box<dyn Any + Send + 'static>,
    method: &Method,
    uri: &Uri,
    headers: &HeaderMap,
) -> Response {
    // Increment the counter used for liveness checks.
    inc_live_counter();

    let current_count = get_live_counter();
    debug!(
        live_counter = current_count,
        "Handling service panic response"
    );

    // If current count is above the threshold, then flag the system as NOT live.
    if current_count > Settings::service_live_counter_threshold() {
        set_not_live();
    }

    let server_err = InternalServerError::new(None);

    // Get the unique identifier for this panic, so we can find it in the logs.
    let panic_identifier = server_err.id().to_string();

    // Get the message from the panic as best we can.
    let err_msg = panic_message(err);

    // This is the location of the panic.
    let location = match LOCATION.with(|l| l.borrow_mut().take()) {
        Some(location) => location,
        None => "Unknown".to_string(),
    };

    // This is the backtrace of the panic.
    let backtrace = match BACKTRACE.with(|b| b.borrow_mut().take()) {
        Some(backtrace) => backtrace,
        None => "Unknown".to_string(),
    };

    error!(
        panic = true,
        backtrace = backtrace,
        location = location,
        id = panic_identifier,
        message = err_msg,
        method = ?method,
        uri = ?uri,
        headers = ?headers,
    );

    let mut resp = Json(server_err).into_response();
    resp.set_status(StatusCode::INTERNAL_SERVER_ERROR);
    resp
}
