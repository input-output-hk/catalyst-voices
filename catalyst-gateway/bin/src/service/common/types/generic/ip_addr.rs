//! `IpAddr` Type.

use poem_openapi::{types::Example, NewType};

/// IP Address.
#[derive(NewType)]
#[oai(example = true)]
pub(crate) struct IpAddr(std::net::IpAddr);

impl Example for IpAddr {
    fn example() -> Self {
        Self(std::net::IpAddr::V4(std::net::Ipv4Addr::new(
            192, 168, 10, 15,
        )))
    }
}

impl From<IpAddr> for std::net::IpAddr {
    fn from(value: IpAddr) -> Self {
        value.0
    }
}
