//! Definition of different channels for the Cardano Chain Indexer

use std::{any::type_name, fmt::Debug};

pub(crate) mod event;
pub(crate) mod state;

/// A helper function to dispatch some message through the
/// `tokio::sync::broadcast::Sender::send`.
fn dispatch_message<T: Debug>(s: &tokio::sync::broadcast::Sender<T>, msg: T) {
    let msg_debug = format!("{msg:?}");
    tracing::debug!(msg = msg_debug, "Dispatching message");
    if let Err(err) = s.send(msg) {
        tracing::error!(error=%err, msg = msg_debug, "Unable to dispatch message. No any active receivers.");
    }
}

/// A helper function to receive some message from the
/// `tokio::sync::broadcast::Receiver::recv`.
/// Return `None` if the channel is closed.
async fn receive_msg<T: Debug + Clone>(r: &mut tokio::sync::broadcast::Receiver<T>) -> Option<T> {
    loop {
        match r.recv().await {
            Ok(msg) => return Some(msg),
            Err(tokio::sync::broadcast::error::RecvError::Lagged(lag)) => {
                tracing::debug!(lag = lag, msg_type = type_name::<T>(), "Receiver lagged");
            },
            Err(tokio::sync::broadcast::error::RecvError::Closed) => return None,
        }
    }
}
