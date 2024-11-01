//! Handle catching panics created by endpoints, logging them and properly responding.
use std::{any::Any, backtrace::Backtrace, cell::RefCell};

use chrono::prelude::*;
use panic_message::panic_message;
use poem::{http::StatusCode, middleware::PanicHandler, IntoResponse};
use poem_openapi::payload::Json;
use serde_json::json;

use crate::service::common::responses::code_500_internal_server_error::InternalServerError;

/// Customized Panic handler.
/// Catches all panics, and turns them into 500.
/// Does not crash the service, BUT will set it to NOT LIVE.
/// Logs the panic as an error.
/// This should cause Kubernetes to restart the service.
#[derive(Clone)]
pub(crate) struct ServicePanicHandler;

// Customized Panic handler - data storage.
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

impl PanicHandler for ServicePanicHandler {
    type Response = poem::Response;

    /// Handle a panic.
    /// Log the panic and respond with a 500 with appropriate data.
    fn get_response(&self, err: Box<dyn Any + Send + 'static>) -> Self::Response {
        let server_err = InternalServerError::new(None);

        // Get the unique identifier for this panic, so we can find it in the logs.
        let panic_identifier = server_err.id().to_string();

        // Get the message from the panic as best we can.
        let err_msg = panic_message(&err);

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

        // For some reason logging doesn't work here.
        // So manually form a log message and send to stdout.
        let time = chrono::Utc::now().to_rfc3339_opts(SecondsFormat::Nanos, true);

        let json_log = json!({
            "backtrace": backtrace,
            "location": location,
            "message": err_msg,
            "id": panic_identifier,
            "level": "PANIC",
            "timestamp": time
        })
        .to_string();

        println!("{json_log}");

        let mut resp = Json(server_err).into_response();
        resp.set_status(StatusCode::INTERNAL_SERVER_ERROR);
        resp
    }
}
