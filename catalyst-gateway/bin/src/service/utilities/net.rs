//! Networking utility functions.
use std::net::{IpAddr, Ipv4Addr, Ipv6Addr, UdpSocket};

use tracing::error;

/// Get the public IPv4 Address of the Service.
///
/// In the unlikely event this fails, the address will be 0.0.0.0
pub(crate) fn get_public_ipv4() -> IpAddr {
    if let Ok(socket) = UdpSocket::bind("0.0.0.0:0") {
        // Note: UDP is connection-less, we don't actually connect to google here.
        if let Err(error) = socket.connect("8.8.8.8:53") {
            error!("Failed to connect IPv4 to Google DNS : {}", error);
        } else if let Ok(local_addr) = socket.local_addr() {
            return local_addr.ip().to_canonical();
        } else {
            error!("Failed to get local address");
        }
    } else {
        error!("Failed to bind IPv4 Address");
    }
    IpAddr::V4(Ipv4Addr::from([0, 0, 0, 0]))
}

/// Get the public IPv4 Address of the Service.
///
/// In the unlikely event this fails, the address will be `::`
pub(crate) fn get_public_ipv6() -> IpAddr {
    if let Ok(socket) = UdpSocket::bind("[::]:0") {
        // Note: UDP is connection-less, we don't actually connect to google here.
        if let Err(error) = socket.connect("[2001:4860:4860::8888]:53") {
            error!("Failed to connect IPv6 to Google DNS : {}", error);
        } else if let Ok(local_addr) = socket.local_addr() {
            return local_addr.ip().to_canonical();
        } else {
            error!("Failed to get local IPv6 address");
        }
    } else {
        error!("Failed to bind IPv6 Address");
    }
    IpAddr::V6(Ipv6Addr::from(0))
}
