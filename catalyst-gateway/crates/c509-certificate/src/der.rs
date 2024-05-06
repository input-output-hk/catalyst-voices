// FIXME - Restructuring, return type

// ANS.1 tags BER-encoded
// Reference: https://www.oss.com/asn1/resources/asn1-made-simple/asn1-quick-reference.html
// Encoding rules reference: https://en.wikipedia.org/wiki/X.690#Encoding
// ASN.1 and DER for X.509 refernece: https://www.zytrax.com/tech/survival/asn1.html

// X509 Certificate should look like
// Certificate  ::=  SIGNED{TBSCertificate}

//   TBSCertificate  ::=  SEQUENCE  {
//       version         [0]  Version DEFAULT v1,
//       serialNumber         CertificateSerialNumber,
//       signature            AlgorithmIdentifier{SIGNATURE-ALGORITHM,
//                                 {SignatureAlgorithms}},
//       issuer               Name,
//       validity             Validity,
//       subject              Name,
//       subjectPublicKeyInfo SubjectPublicKeyInfo,
//       ... ,
//       [[2:               -- If present, version MUST be v2
//       issuerUniqueID  [1]  IMPLICIT UniqueIdentifier OPTIONAL,
//       subjectUniqueID [2]  IMPLICIT UniqueIdentifier OPTIONAL
//       ]],
//       [[3:               -- If present, version MUST be v3 --
//       extensions      [3]  Extensions{{CertExtensions}} OPTIONAL
//       ]], ... }


// pub const ASN1_BOOL: u8 = 0x01;
pub const ASN1_INT: u8 = 0x02;
// pub const ASN1_BIT_STR: u8 = 0x03;
// pub const ASN1_OCTET_STR: u8 = 0x04;
// pub const ASN1_OID: u8 = 0x06;
// pub const ASN1_UTF8_STR: u8 = 0x0C;
// pub const ASN1_PRINT_STR: u8 = 0x13;
// pub const ASN1_IA5_SRT: u8 = 0x16;
// pub const ASN1_UTC_TIME: u8 = 0x17;
// pub const ASN1_GEN_TIME: u8 = 0x18;
pub const ASN1_SEQ: u8 = 0x30; // Tag 16, but is a constructed form
// pub const ASN1_SET: u8 = 0x31; // Tag 17, but is a constructed form
pub const ASN1_VERSION: u8 = 0xa0; // For version
pub const ASN1_EXTENSION_ADDITION_GROUP_3: u8 = 0xa3;

#[allow(unused)]
pub fn extract_der_value_by_tag(b: &[u8], tag: u8) {
    // The first byte should match the tag
    if b[0] != tag {
        // return Err(Error::InvalidData);
        println!("Error");
    } else {
        println!("Tag matched");
    }
}

// Extracting the length of TLV
// Length in TLV can be in 2 form - short form and long form.
// - Short form: the 8th bit is set to 0, and the remaining 7 bits are the actual length.
// - Long form: the 8th bit is set to 1, and the remaining 7 bits are the number of octet N.
// - Indefinite form: the byte is equal to 0x80.

// For TLV Long form, it does not have a fixed length, so in this lib, the maximum length of N is 3 octet.
// - 0x81 represent N = 1 octet
// - 0x82 represent N = 2 octet
// - 0x83 represent N = 3 octet
// If the length is more than 3 octet, it is not supported in this lib.

// Params
// - b: byte string
// - value_only: boolean to indicate whether to return the value V only or the whole TLV

// Return
// - Tuple of byte string that want to extract and the remaining byte string
#[allow(unused)]
fn extract_value_by_length(b: &[u8], value_only: bool) -> (&[u8], &[u8]) {
    let length = b[1];

    // Length should not exceed 4 octet.
    if length >= 0x84 {
        // return  Err(Error::InvalidData);
        println!("Error");
    }

    let (start, end) = match length {
        0x80 => {
            // Indefinite form
            // return Err(Error::InvalidData);
            println!("Error");
            (0, 0)
        },
        // Long form
        0x81 => (3, 3 + b[2] as usize),
        0x82 => (4, 4 + bytes_to_u64(&b[2..4]) as usize),
        0x83 => (5, 5 + bytes_to_u64(&b[2..5]) as usize),
        // Short form
        _ => (2, 2 + length as usize),
    };

    let result = (&b[value_only as usize * start..end], &b[end..]);
    result
}

#[allow(unused)]
// Convert byte string to u64
fn bytes_to_u64(bytes: &[u8]) -> u64 {
    let mut result = 0u64;
    for &byte in bytes {
        result = (result << 8) | u64::from(byte);
    }
    result
}

// Parse a DER encoded tag and returns the value
#[allow(unused)]
pub fn parse_der_tag(b: &[u8], tag: u8) -> &[u8] {
    // Every first byte of TLV should match the given tag
    if b[0] != tag {
        println!("b[0] {} not equal to tag {}", b[0], tag);
        return &[];
    }

    println!("{:?}", b);
    // Want only the value V
    let (value, _) = extract_value_by_length(b, true);
    value
}

// Parse a DER encoded sequence/set
#[allow(unused)]
pub fn parse_der_sequence_set(b: &[u8], tag: u8) -> Vec<&[u8]> {
    let mut vec = Vec::new();
    let mut value = parse_der_tag(b, tag);

    while !value.is_empty() {
        let (tlv, temp) = extract_value_by_length(value, false);
        vec.push(tlv);
        value = temp;
    }
    vec
}

#[cfg(test)]
#[allow(unused)]
mod tests {

    use super::*;

    // Long form length
    // 0x30 indicates tag for SEQUENCE
    // 0x82 indicates long form length with N = 2
    // 0x01, 0x38 indicates length of 312
    const CERT: [u8; 316] = [
        0x30, 0x82, 0x01, 0x38, 0x30, 0x81, 0xde, 0xa0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x03, 0x01,
        0xf5, 0x0d, 0x30, 0x0a, 0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x04, 0x03, 0x02, 0x30,
        0x16, 0x31, 0x14, 0x30, 0x12, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0c, 0x0b, 0x52, 0x46, 0x43,
        0x20, 0x74, 0x65, 0x73, 0x74, 0x20, 0x43, 0x41, 0x30, 0x1e, 0x17, 0x0d, 0x32, 0x33, 0x30,
        0x31, 0x30, 0x31, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x5a, 0x17, 0x0d, 0x32, 0x36, 0x30,
        0x31, 0x30, 0x31, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x5a, 0x30, 0x22, 0x31, 0x20, 0x30,
        0x1e, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0c, 0x17, 0x30, 0x31, 0x2d, 0x32, 0x33, 0x2d, 0x34,
        0x35, 0x2d, 0x46, 0x46, 0x2d, 0x46, 0x45, 0x2d, 0x36, 0x37, 0x2d, 0x38, 0x39, 0x2d, 0x41,
        0x42, 0x30, 0x59, 0x30, 0x13, 0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, 0x01, 0x06,
        0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07, 0x03, 0x42, 0x00, 0x04, 0xb1, 0x21,
        0x6a, 0xb9, 0x6e, 0x5b, 0x3b, 0x33, 0x40, 0xf5, 0xbd, 0xf0, 0x2e, 0x69, 0x3f, 0x16, 0x21,
        0x3a, 0x04, 0x52, 0x5e, 0xd4, 0x44, 0x50, 0xb1, 0x01, 0x9c, 0x2d, 0xfd, 0x38, 0x38, 0xab,
        0xac, 0x4e, 0x14, 0xd8, 0x6c, 0x09, 0x83, 0xed, 0x5e, 0x9e, 0xef, 0x24, 0x48, 0xc6, 0x86,
        0x1c, 0xc4, 0x06, 0x54, 0x71, 0x77, 0xe6, 0x02, 0x60, 0x30, 0xd0, 0x51, 0xf7, 0x79, 0x2a,
        0xc2, 0x06, 0xa3, 0x0f, 0x30, 0x0d, 0x30, 0x0b, 0x06, 0x03, 0x55, 0x1d, 0x0f, 0x04, 0x04,
        0x03, 0x02, 0x07, 0x80, 0x30, 0x0a, 0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x04, 0x03,
        0x02, 0x03, 0x49, 0x00, 0x30, 0x46, 0x02, 0x21, 0x00, 0xd4, 0x32, 0x0b, 0x1d, 0x68, 0x49,
        0xe3, 0x09, 0x21, 0x9d, 0x30, 0x03, 0x7e, 0x13, 0x81, 0x66, 0xf2, 0x50, 0x82, 0x47, 0xdd,
        0xda, 0xe7, 0x6c, 0xce, 0xea, 0x55, 0x05, 0x3c, 0x10, 0x8e, 0x90, 0x02, 0x21, 0x00, 0xd5,
        0x51, 0xf6, 0xd6, 0x01, 0x06, 0xf1, 0xab, 0xb4, 0x84, 0xcf, 0xbe, 0x62, 0x56, 0xc1, 0x78,
        0xe4, 0xac, 0x33, 0x14, 0xea, 0x19, 0x19, 0x1e, 0x8b, 0x60, 0x7d, 0xa5, 0xae, 0x3b, 0xda,
        0x16,
    ];

    // Parse into section for tbs certificate
    // Version [160, 3, 2, 1, 2]
    // Serial Number [2, 3, 1, 245, 13]
    // Signature [48, 10, 6, 8, 42, 134, 72, 206, 61, 4, 3, 2]
    // Issuer [48, 22, 49, 20, 48, 18, 6, 3, 85, 4, 3, 12, 11, 82, 70, 67, 32, 116, 101, 115, 116, 32, 67, 65]
    // Validity [48, 30, 23, 13, 50, 51, 48, 49, 48, 49, 48, 48, 48, 48, 48, 48, 90, 23, 13, 50, 54, 48, 49, 48, 49, 48, 48, 48, 48, 48, 48, 90]
    // Subject [48, 34, 49, 32, 48, 30, 6, 3, 85, 4, 3, 12, 23, 48, 49, 45, 50, 51, 45, 52, 53, 45, 70, 70, 45, 70, 69, 45, 54, 55, 45, 56, 57, 45, 65, 66]
    // SubjectPublicKeyInfo [48, 89, 48, 19, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 8, 42, 134, 72, 206, 61, 3, 1, 7, 3, 66, 0, 4, 177, 33, 106, 185, 110, 91, 59, 51, 64, 245, 189, 240, 46, 105, 63, 22, 33, 58, 4, 82, 94, 212, 68, 80, 177, 1, 156, 45, 253, 56, 56, 171, 172, 78, 20, 216, 108, 9, 131, 237, 94, 158, 239, 36, 72, 198, 134, 28, 196, 6, 84, 113, 119, 230, 2, 96, 48, 208, 81, 247, 121, 42, 194, 6]
    // Extension [163, 15, 48, 13, 48, 11, 6, 3, 85, 29, 15, 4, 4, 3, 2, 7, 128]

    #[test]
    fn test_extract_value_by_length() {
        let certificate = parse_der_sequence_set(&CERT, ASN1_SEQ);
        // x509 certificate has 3 elements including tbscertificate, signature algorithm, and signature value
        // ref: https://datatracker.ietf.org/doc/html/rfc5280#section-4.1
        assert_eq!(certificate.len(), 3);

        // TBS Certificate
        let tbs_certificate = parse_der_sequence_set(certificate[0], 0x30);

        // Only support X.509 v3
        let version = parse_der_tag(tbs_certificate[0], ASN1_VERSION);
        // Version  ::=  INTEGER  {  v1(0), v2(1), v3(2)  }
        if parse_der_tag(version, ASN1_INT)[0] == 2 {
            println!("X.509 v3");
        }

        let serial_number = parse_der_tag(tbs_certificate[1], ASN1_INT);
        let signature = parse_der_tag(tbs_certificate[2], ASN1_SEQ);
        let issuer = parse_der_tag(tbs_certificate[3], ASN1_SEQ);
        let validity = parse_der_tag(tbs_certificate[4], ASN1_SEQ);
        let subject = parse_der_tag(tbs_certificate[5], ASN1_SEQ);
        let subject_public_key_info = parse_der_tag(tbs_certificate[6], ASN1_SEQ);
        let extensions = parse_der_tag(tbs_certificate[7], ASN1_EXTENSION_ADDITION_GROUP_3);
    }
}
