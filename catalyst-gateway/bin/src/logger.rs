//! Setup for logging for the service.

use clap::ValueEnum;
use tracing::level_filters::LevelFilter;
use tracing_subscriber::{
    fmt::{self, format::FmtSpan, time},
    prelude::*,
    reload::{self, Handle},
    Registry,
};

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

/// Initialize the tracing subscriber
pub(crate) fn init(log_level: LogLevel) -> Handle<LevelFilter, Registry> {
    // Create the formatting layer
    let layer = fmt::layer()
        .json()
        .with_timer(time::UtcTime::rfc_3339())
        .with_span_events(FmtSpan::CLOSE)
        .with_target(true)
        .with_file(true)
        .with_line_number(true)
        .with_level(true)
        .with_thread_names(true)
        .with_thread_ids(true)
        .with_current_span(true)
        .with_span_list(true);
    // Create a reloadable layer with the specified log_level
    let filter = LevelFilter::from_level(log_level.into());
    let (filter, logger_handle) = reload::Layer::new(filter);
    tracing_subscriber::registry()
        .with(filter)
        .with(layer)
        .init();

    // Logging is globally disabled by default, so globally enable it to the required level.
    tracing::log::set_max_level(log_level.into());

    logger_handle
}
