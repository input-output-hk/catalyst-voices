
// ANS.1 tags BER-encoded
// Reference: https://www.oss.com/asn1/resources/asn1-made-simple/asn1-quick-reference.html
// Encoding rules reference: https://en.wikipedia.org/wiki/X.690#Encoding
pub const ASN1_BOOL: u8 = 0x01;
pub const ASN1_INT: u8 = 0x02;
pub const ASN1_BIT_STR: u8 = 0x03;
pub const ASN1_OCTET_STR: u8 = 0x04;
pub const ASN1_OID: u8 = 0x06;
pub const ASN1_UTF8_STR: u8 = 0x0C;
pub const ASN1_PRINT_STR: u8 = 0x13;
pub const ASN1_IA5_SRT: u8 = 0x16;
pub const ASN1_UTC_TIME: u8 = 0x17;
pub const ASN1_GEN_TIME: u8 = 0x18;         
pub const ASN1_SEQ: u8 = 0x30; // Tag 16, but is a constructed form
pub const ASN1_SET: u8 = 0x31; // Tag 17, but is a constructed form
// pub const ASN1_INDEX_ZERO: u8 = 0xa0;
// pub const ASN1_INDEX_ONE: u8 = 0xa1;

pub fn extract_der_value_by_tag(b: &[u8], tag: u8) -> Result<&[u8], Error> {
    // The first byte should match the tag
    if b[0] != tag {
        return Err(Error::InvalidData);
    }
}
