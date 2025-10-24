//! An implementation of the panic endpoint.

/// Implementation of the special `/panic` endpoint,
/// which is used only for testing purposes and enabled for all networks except `Mainnet`
#[poem::handler]
#[allow(clippy::panic)]
pub(crate) fn panic_endpoint() {
    panic!("Intentional panicking")
}
