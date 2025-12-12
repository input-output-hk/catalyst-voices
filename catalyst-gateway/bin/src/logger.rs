//! Setup for logging for the service.

use std::sync::OnceLock;

use clap::ValueEnum;
use tracing::{Subscriber, level_filters::LevelFilter, log::error};
use tracing_subscriber::{
    Layer, Registry,
    fmt::{self, format::FmtSpan, time},
    prelude::*,
    registry::LookupSpan,
    reload::{self, Handle},
};

use crate::settings::Settings;
/// Default log level
pub(crate) const LOG_LEVEL_DEFAULT: &str = "info";

/// All valid logging levels
#[derive(ValueEnum, Clone, Copy, Debug)]
pub(crate) enum LogLevel {
    /// Debug messages
    Debug,
    /// Informational Messages
    Info,
    /// Warnings
    Warn,
    /// Errors
    Error,
}

impl From<LogLevel> for tracing::Level {
    fn from(val: LogLevel) -> Self {
        match val {
            LogLevel::Debug => Self::DEBUG,
            LogLevel::Info => Self::INFO,
            LogLevel::Warn => Self::WARN,
            LogLevel::Error => Self::ERROR,
        }
    }
}

impl From<LogLevel> for tracing::log::LevelFilter {
    fn from(val: LogLevel) -> Self {
        match val {
            LogLevel::Debug => Self::Debug,
            LogLevel::Info => Self::Info,
            LogLevel::Warn => Self::Warn,
            LogLevel::Error => Self::Error,
        }
    }
}

/// Logger Handle for the Service.
static LOGGER_HANDLE: OnceLock<LoggerHandle> = OnceLock::new();

/// Default Span Guard for the Service.
static GLOBAL_SPAN: OnceLock<tracing::span::Span> = OnceLock::new();

/// Default Span Guard for the Service.
static SPAN_GUARD: OnceLock<tracing::span::Entered> = OnceLock::new();

/// Handle to our Logger
pub(crate) type LoggerHandle = Handle<LevelFilter, Registry>;

/// Set the default fields in a log, using a global span.
fn set_default_span() {
    let server_id = Settings::service_id();
    // This is a hacky way to add fields to every log line.
    // Add Fields here, as required.
    let global_span = tracing::info_span!("Global", ServerID = server_id);
    if GLOBAL_SPAN.set(global_span).is_err() {
        error!("Failed to set default span.  Is it already set?");
    }

    // It MUST be Some because of the above.
    if let Some(global_span) = GLOBAL_SPAN.get() {
        let span_guard = global_span.enter();
        if SPAN_GUARD.set(span_guard).is_err() {
            error!("Failed to set default span.  Is it already set?");
        }
    }
}

/// Initialize the tracing subscriber
pub(crate) fn build_fmt_layer<S>() -> Box<dyn Layer<S> + Send + Sync + 'static>
where
    S: Subscriber,
    for<'a> S: LookupSpan<'a>,
{
    // Create the formatting layer
    fmt::layer()
        .json()
        .with_timer(time::UtcTime::rfc_3339())
        .with_span_events(FmtSpan::CLOSE)
        .with_current_span(true)
        .with_span_list(true)
        .with_target(true)
        .with_file(true)
        .with_line_number(true)
        .with_level(true)
        .with_thread_names(true)
        .with_thread_ids(true)
        .flatten_event(true)
        .boxed()
}

/// Create a reloadable layer with the specified `log_level`.
///
/// Initializes the `LOGGER_HANDLE` static variable, which can be used to modify the log
/// level with the `modify_logger_level` function.
pub(crate) fn build_reloadable_filter(log_level: LogLevel) -> reload::Layer<LevelFilter, Registry> {
    let filter = LevelFilter::from_level(log_level.into());
    let (filter, logger_handle) = reload::Layer::new(filter);

    if LOGGER_HANDLE.set(logger_handle).is_err() {
        error!("Failed to initialize logger handle. Called multiple times?");
    }
    filter
}

/// Initialize the tracing subscriber
pub(crate) fn init(log_level: LogLevel) {
    // Create the formatting layer
    let layer = build_fmt_layer();

    // Create a reloadable layer with the specified log_level
    let filter = build_reloadable_filter(log_level);

    tracing_subscriber::registry()
        .with(filter)
        .with(layer)
        .with(
            tracing_subscriber::EnvFilter::builder()
                .with_default_directive(LevelFilter::INFO.into())
                .from_env_lossy(),
        )
        .init();

    post_init(log_level);
}

/// Initialize the tracing subscriber
pub(crate) fn post_init(log_level: LogLevel) {
    // Logging is globally disabled by default, so globally enable it to the required level.
    tracing::log::set_max_level(log_level.into());
    set_default_span();
}

/// Modify the logger level setting.
/// This will reload the logger.
pub(crate) fn modify_logger_level(level: LogLevel) {
    if let Some(logger_handle) = LOGGER_HANDLE.get() {
        if let Err(error) = logger_handle.modify(|f| *f = LevelFilter::from_level(level.into())) {
            error!("Failed to modify log level to {level:?} : {error}");
        }
    } else {
        // This should never happen.
        error!("Failed to modify log level to {level:?} : Logger handle not available.",);
    }
}
