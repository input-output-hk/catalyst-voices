// cspell: words hier, VCHAR

/*
/// A struct represents an Endpoint IDentifier (EID) in the Bundle Protocol.
/// EID structure define in [RFC9171](https://datatracker.ietf.org/doc/rfc9171/)
///
/// # Fields
/// * `uri_code` - The URI code of the EID.
/// * `ssp` - The Scheme Specific Part (SSP) of the EID.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub(crate) struct Eid {
    uri_code: BundleProtocolURISchemeTypes,
    ssp: String,
}

/// An Enum of `BundleProtocolURISchemeTypes` defines the type of URI scheme
/// URI Scheme can be found in [RFC9171](https://datatracker.ietf.org/doc/rfc9171/) Section 9.7
///
/// DTN scheme syntax
/// ```text
/// dtn-uri = "dtn:" ("none" / dtn-hier-part)
/// dtn-hier-part = "//" node-name name-delim demux ; a path-rootless
/// node-name = reg-name
/// name-delim = "/"
/// demux = *VCHAR
/// ```
/// Note that - *VCHAR consists of zero or more visible characters
/// Example dtn://node1/service1/data
///
/// IPN scheme syntax
/// ```text
/// ipn-uri = "ipn:" ipn-hier-part
/// ipn-hier-part = node-nbr nbr-delim service-nbr ; a path-rootless
/// node-nbr = 1*DIGIT
/// nbr-delim = "."
/// service-nbr = 1*DIGIT
/// ```
/// Note that 1*DIGIT consists of one or more digits
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub(crate) enum BundleProtocolURISchemeTypes {
    Dtn,
    Ipn,
}

impl BundleProtocolURISchemeTypes {
    /// Convert the integer value to associated BundleProtocolURISchemeTypes.
    fn from_int(value: u8) -> Option<Self> {
        match value {
            1 => Some(BundleProtocolURISchemeTypes::Dtn),
            2 => Some(BundleProtocolURISchemeTypes::Ipn),
            _ => None,
        }
    }
}

impl Eid {
    /// Create a new instance of Eid.
    pub fn new(uri_code: BundleProtocolURISchemeTypes, ssp: String) -> Self {
        Self { uri_code, ssp }
    }
}

impl Encode<()> for Eid {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, _ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.array(2)?;
        e.u8(self.uri_code.clone() as u8)?;
        e.bytes(&self.ssp.as_bytes())?;
        Ok(())
    }
}

impl<'a> Decode<'a, ()> for Eid {
    fn decode(d: &mut Decoder<'a>, _ctx: &mut ()) -> Result<Self, decode::Error> {
        d.array()?;
        let uri_code = d.u8()?;
        let ssp = d.bytes()?;
        Ok(Eid::new(
            BundleProtocolURISchemeTypes::from_int(uri_code).ok_or(decode::Error::message(
                format!("Invalid uri code value, provided {uri_code}"),
            ))?,
            String::from_utf8(ssp.to_vec())
                .map_err(|_| decode::Error::message("Failed to convert bytes to string"))?,
        ))
    }
}
*/
