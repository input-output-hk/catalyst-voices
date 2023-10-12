use clap::ValueEnum;
use tracing::{level_filters::LevelFilter, subscriber::SetGlobalDefaultError};
use tracing_subscriber::{
    fmt::{format::FmtSpan, time},
    FmtSubscriber,
};

pub const LOG_LEVEL_DEFAULT: &str = "info";

#[derive(ValueEnum, Clone)]
pub enum LogLevel {
    Info,
    Debug,
    Warn,
    Error,
}

impl From<LogLevel> for tracing::Level {
    fn from(val: LogLevel) -> Self {
        match val {
            LogLevel::Info => Self::INFO,
            LogLevel::Debug => Self::DEBUG,
            LogLevel::Warn => Self::WARN,
            LogLevel::Error => Self::ERROR,
        }
    }
}

impl LogLevel {
    pub fn as_log_level(&self) -> tracing::log::LevelFilter {
        match self {
            LogLevel::Info => tracing::log::LevelFilter::Info,
            LogLevel::Debug => tracing::log::LevelFilter::Debug,
            LogLevel::Warn => tracing::log::LevelFilter::Warn,
            LogLevel::Error => tracing::log::LevelFilter::Error,
        }
    }
}

/// Initialize the tracing subscriber
pub(crate) fn init(log_level: LogLevel) -> Result<(), SetGlobalDefaultError> {
    let subscriber = FmtSubscriber::builder()
        .json()
        .with_max_level(LevelFilter::from_level(log_level.clone().into()))
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
    tracing::log::set_max_level(log_level.as_log_level());

    tracing::subscriber::set_global_default(subscriber)
}
