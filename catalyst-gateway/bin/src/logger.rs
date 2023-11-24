//! Setup for logging for the service.
use clap::ValueEnum;
use tracing::{level_filters::LevelFilter, subscriber::SetGlobalDefaultError};
use tracing_subscriber::{
    fmt::{format::FmtSpan, time},
    FmtSubscriber,
};

/// Default log level
pub(crate) const LOG_LEVEL_DEFAULT: &str = "info";

/// All valid logging levels
#[derive(ValueEnum, Clone, Copy)]
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
pub(crate) fn init(log_level: LogLevel) -> Result<(), SetGlobalDefaultError> {
    let subscriber = FmtSubscriber::builder()
        .json()
        .with_max_level(LevelFilter::from_level(log_level.into()))
        .with_timer(time::UtcTime::rfc_3339())
        .with_span_events(FmtSpan::CLOSE)
        .with_target(true)
        .with_file(true)
        .with_line_number(true)
        .with_level(true)
        .with_thread_names(true)
        .with_thread_ids(true)
        .with_current_span(true)
        .with_span_list(true)
        .finish();

    // Logging is globally disabled by default, so globally enable it to the required level.
    tracing::log::set_max_level(log_level.into());

    tracing::subscriber::set_global_default(subscriber)
}
