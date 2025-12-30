//! Open Telemetry support
use std::sync::OnceLock;

use opentelemetry::{InstrumentationScope, global, trace::TracerProvider};
//use opentelemetry_appender_tracing::layer::OpenTelemetryTracingBridge;
use opentelemetry_otlp::{LogExporter, MetricExporter, SpanExporter};
use opentelemetry_sdk::{
    Resource, logs::SdkLoggerProvider, metrics::SdkMeterProvider, trace::SdkTracerProvider,
};
use tracing::{error, info, level_filters::LevelFilter};
use tracing_opentelemetry::MetricsLayer;
use tracing_subscriber::prelude::*;

use crate::logger::LogLevel;

/// Return the common `Resource`
fn get_resource() -> Resource {
    static RESOURCE: OnceLock<Resource> = OnceLock::new();
    RESOURCE.get_or_init(|| Resource::builder().build()).clone()
}

/// Telemetry Handle
pub(crate) struct TelemetryGuard {
    /// Logging handle
    logging: SdkLoggerProvider,
    /// Traces handle
    traces: SdkTracerProvider,
    /// Metrics handle
    metrics: SdkMeterProvider,
}

impl TelemetryGuard {
    /// Return Log Provider
    fn init() -> anyhow::Result<Self> {
        let exporter = LogExporter::builder().with_tonic().build()?;
        let logging = SdkLoggerProvider::builder()
            .with_resource(get_resource())
            .with_batch_exporter(exporter)
            .build();
        let exporter = SpanExporter::builder().with_tonic().build()?;
        let traces = SdkTracerProvider::builder()
            .with_resource(get_resource())
            .with_batch_exporter(exporter)
            .build();

        global::set_tracer_provider(traces.clone());

        let exporter = MetricExporter::builder().with_tonic().build()?;
        let metrics = SdkMeterProvider::builder()
            .with_periodic_exporter(exporter)
            .with_resource(get_resource())
            .build();

        global::set_meter_provider(metrics.clone());

        Ok(Self {
            logging,
            traces,
            metrics,
        })
    }
}

impl Drop for TelemetryGuard {
    fn drop(&mut self) {
        info!("dropping telemetry providers");
        if let Err(e) = self.logging.shutdown() {
            error!("logger provider did not shutdown: {e}");
        }
        if let Err(e) = self.traces.shutdown() {
            error!("tracer provider did not shutdown: {e}");
        }
        if let Err(e) = self.metrics.shutdown() {
            error!("metrics provider did not shutdown: {e}");
        }
    }
}

/// Initialize telemetry.
pub(crate) fn init(log_level: LogLevel) -> anyhow::Result<TelemetryGuard> {
    let telemetry_provider = TelemetryGuard::init()?;
    // NOTE: OTEL log storage need to be configured with the batch exporter for them to work.
    //       OTEL logs are currently disabled.
    // let otel_log_layer = OpenTelemetryTracingBridge::new(&telemetry_provider.logging);
    let scope = InstrumentationScope::builder("cat-gateway telemetry")
        .with_version("1.0")
        .build();

    let tracer = telemetry_provider.traces.tracer_with_scope(scope);
    let tracer_layer = tracing_opentelemetry::layer().with_tracer(tracer.clone());

    let metrics_layer = MetricsLayer::new(telemetry_provider.metrics.clone());

    // Create a new tracing::Fmt layer to print the logs to stdout. It has a
    // default filter of `info` level and above, and `debug` and above for logs
    // from OpenTelemetry crates. The filter levels can be customized as needed.
    let filter_layer = super::logger::build_reloadable_filter(log_level);
    let fmt_layer = super::logger::build_fmt_layer();

    // Initialize the tracing subscriber with the OpenTelemetry layer and the
    // Fmt layer.
    tracing_subscriber::registry()
        .with(filter_layer)
        .with(tracer_layer)
        .with(metrics_layer)
        //.with(otel_log_layer)
        .with(fmt_layer)
        .with(
            tracing_subscriber::EnvFilter::builder()
                .with_default_directive(LevelFilter::DEBUG.into())
                .from_env_lossy(),
        )
        .init();

    super::logger::post_init(log_level);

    // At this point Logs (OTel Logs and Fmt Logs) are initialized, which will
    // allow internal-logs from Tracing/Metrics initializer to be captured.

    Ok(telemetry_provider)
}
