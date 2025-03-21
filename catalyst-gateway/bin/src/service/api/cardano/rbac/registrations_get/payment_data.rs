//! TODO: FIXME:

use poem_openapi::{types::Example, Object};

///  TODO: FIXME:
#[derive(Object, Debug, Clone)]
pub(crate) struct PaymentData {}

// TODO: FIXME:
// payment_address: [time, cip19_address],

impl Example for PaymentData {
    fn example() -> Self {
        Self {}
    }
}
