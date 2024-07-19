//! To Be Sign Certificate (TBS Certificate) use to construct a C509 certificate.

use minicbor::{encode::Write, Decode, Decoder, Encode, Encoder};
use serde::{Deserialize, Serialize};

use crate::{
    c509_big_uint::UnwrappedBigUint, c509_extensions::Extensions,
    c509_issuer_sig_algo::IssuerSignatureAlgorithm, c509_name::Name,
    c509_subject_pub_key_algo::SubjectPubKeyAlgorithm, c509_time::Time,
};

/// A struct represents a To Be Signed Certificate (TBS Certificate).
#[derive(Debug, Clone, PartialEq, Deserialize, Serialize)]
pub struct TbsCert {
    /// Certificate type.
    c509_certificate_type: u8,
    /// Serial number of the certificate.
    certificate_serial_number: UnwrappedBigUint,
    /// Issuer
    issuer: Name,
    /// Validity not before.
    validity_not_before: Time,
    /// Validity not after.
    validity_not_after: Time,
    /// Subject
    subject: Name,
    /// Subject Public Key Algorithm
    subject_public_key_algorithm: SubjectPubKeyAlgorithm,
    /// Subject Public Key value
    subject_public_key: Vec<u8>,
    /// Extensions
    extensions: Extensions,
    /// Issuer Signature Algorithm
    issuer_signature_algorithm: IssuerSignatureAlgorithm,
}

impl TbsCert {
    /// Create a new instance of TBS Certificate.
    #[must_use]
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        c509_certificate_type: u8, certificate_serial_number: UnwrappedBigUint, issuer: Name,
        validity_not_before: Time, validity_not_after: Time, subject: Name,
        subject_public_key_algorithm: SubjectPubKeyAlgorithm, subject_public_key: Vec<u8>,
        extensions: Extensions, issuer_signature_algorithm: IssuerSignatureAlgorithm,
    ) -> Self {
        Self {
            c509_certificate_type,
            certificate_serial_number,
            issuer,
            validity_not_before,
            validity_not_after,
            subject,
            subject_public_key_algorithm,
            subject_public_key,
            extensions,
            issuer_signature_algorithm,
        }
    }

    /// Get the certificate type.
    #[must_use]
    pub fn get_c509_certificate_type(&self) -> u8 {
        self.c509_certificate_type
    }

    /// Get the certificate serial number.
    #[must_use]
    pub fn get_certificate_serial_number(&self) -> &UnwrappedBigUint {
        &self.certificate_serial_number
    }

    /// Get the issuer.
    #[must_use]
    pub fn get_issuer(&self) -> &Name {
        &self.issuer
    }

    /// Get the validity not before.
    #[must_use]
    pub fn get_validity_not_before(&self) -> &Time {
        &self.validity_not_before
    }

    /// Get the validity not after.
    #[must_use]
    pub fn get_validity_not_after(&self) -> &Time {
        &self.validity_not_after
    }

    /// Get the subject.
    #[must_use]
    pub fn get_subject(&self) -> &Name {
        &self.subject
    }

    /// Get the subject public key algorithm.
    #[must_use]
    pub fn get_subject_public_key_algorithm(&self) -> &SubjectPubKeyAlgorithm {
        &self.subject_public_key_algorithm
    }

    /// Get the subject public key.
    #[must_use]
    pub fn get_subject_public_key(&self) -> &[u8] {
        &self.subject_public_key
    }

    /// Get the extensions.
    #[must_use]
    pub fn get_extensions(&self) -> &Extensions {
        &self.extensions
    }

    /// Get the issuer signature algorithm.
    #[must_use]
    pub fn get_issuer_signature_algorithm(&self) -> &IssuerSignatureAlgorithm {
        &self.issuer_signature_algorithm
    }
}

impl Encode<()> for TbsCert {
    fn encode<W: Write>(
        &self, e: &mut Encoder<W>, ctx: &mut (),
    ) -> Result<(), minicbor::encode::Error<W::Error>> {
        e.u8(self.c509_certificate_type)?;
        self.certificate_serial_number.encode(e, ctx)?;
        self.issuer.encode(e, ctx)?;
        self.validity_not_before.encode(e, ctx)?;
        self.validity_not_after.encode(e, ctx)?;
        self.subject.encode(e, ctx)?;
        self.subject_public_key_algorithm.encode(e, ctx)?;
        e.bytes(&self.subject_public_key)?;
        self.extensions.encode(e, ctx)?;
        self.issuer_signature_algorithm.encode(e, ctx)?;
        Ok(())
    }
}

impl Decode<'_, ()> for TbsCert {
    fn decode(d: &mut Decoder<'_>, ctx: &mut ()) -> Result<Self, minicbor::decode::Error> {
        let cert_type = d.u8()?;
        let serial_number = UnwrappedBigUint::decode(d, ctx)?;
        let issuer = Name::decode(d, ctx)?;
        let not_before = Time::decode(d, ctx)?;
        let not_after = Time::decode(d, ctx)?;
        let subject = Name::decode(d, ctx)?;
        let subject_public_key_algorithm = SubjectPubKeyAlgorithm::decode(d, ctx)?;
        let subject_public_key = d.bytes()?;
        let extensions = Extensions::decode(d, ctx)?;
        let issuer_signature_algorithm = IssuerSignatureAlgorithm::decode(d, ctx)?;

        Ok(TbsCert::new(
            cert_type,
            serial_number,
            issuer,
            not_before,
            not_after,
            subject,
            subject_public_key_algorithm,
            subject_public_key.to_vec(),
            extensions,
            issuer_signature_algorithm,
        ))
    }
}

// ------------------Test----------------------

// Notes
// - Test is modified to match the current encode and decode where `subject_public_key`
//   doesn't support
// special case for rsaEncryption and id-ecPublicKey.
// - Currently support natively signed c509 certificate, so all text strings
// are UTF-8 encoded and all attributeType SHALL be non-negative
// - Some Extension values are not supported yet.

#[cfg(test)]
pub(crate) mod test_tbs_cert {
    use asn1_rs::oid;

    use super::*;
    use crate::{
        c509_attributes::attribute::{Attribute, AttributeValue},
        c509_extensions::{
            alt_name::{AlternativeName, GeneralNamesOrText},
            extension::{Extension, ExtensionValue},
        },
        c509_general_names::{
            general_name::{GeneralName, GeneralNameTypeRegistry, GeneralNameValue},
            other_name_hw_module::OtherNameHardwareModuleName,
            GeneralNames,
        },
        c509_name::{
            rdn::RelativeDistinguishedName,
            test_name::{name_cn_eui_mac, name_cn_text, names},
            NameValue,
        },
    };

    // Mnemonic: match mad promote group rival case
    const PUBKEY: [u8; 8] = [0x88, 0xD0, 0xB6, 0xB0, 0xB3, 0x7B, 0xAA, 0x46];

    // Test reference https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
    // A.1.  Example RFC 7925 profiled X.509 Certificate
    //
    //
    // Certificate:
    // Data:
    // Version: 3 (0x2)
    // Serial Number: 128269 (0x1f50d)
    // Signature Algorithm: ecdsa-with-SHA256
    // Issuer: CN=RFC test CA
    // Validity
    // Not Before: Jan  1 00:00:00 2023 GMT
    // Not After : Jan  1 00:00:00 2026 GMT
    // Subject: CN=01-23-45-FF-FE-67-89-AB
    // Subject Public Key Info:
    // Public Key Algorithm: id-ecPublicKey
    // Public-Key: (256 bit)
    // pub:
    // 04:b1:21:6a:b9:6e:5b:3b:33:40:f5:bd:f0:2e:69:
    // 3f:16:21:3a:04:52:5e:d4:44:50:b1:01:9c:2d:fd:
    // 38:38:ab:ac:4e:14:d8:6c:09:83:ed:5e:9e:ef:24:
    // 48:c6:86:1c:c4:06:54:71:77:e6:02:60:30:d0:51:
    // f7:79:2a:c2:06
    // ASN1 OID: prime256v1
    // NIST CURVE: P-256
    // X509v3 extensions:
    // X509v3 Key Usage:
    // Digital Signature
    // Signature Algorithm: ecdsa-with-SHA256
    // 30:46:02:21:00:d4:32:0b:1d:68:49:e3:09:21:9d:30:03:7e:
    // 13:81:66:f2:50:82:47:dd:da:e7:6c:ce:ea:55:05:3c:10:8e:
    // 90:02:21:00:d5:51:f6:d6:01:06:f1:ab:b4:84:cf:be:62:56:
    // c1:78:e4:ac:33:14:ea:19:19:1e:8b:60:7d:a5:ae:3b:da:16
    //
    // 01
    // 43 01 F5 0D
    // 6B 52 46 43 20 74 65 73 74 20 43 41
    // 1A 63 B0 CD 00
    // 1A 69 55 B9 00
    // 47 01 01 23 45 67 89 AB
    // 01
    // 58 21 02 B1 21 6A B9 6E 5B 3B 33 40 F5 BD F0 2E 69 3F 16 21 3A 04 52
    // 5E D4 44 50 B1 01 9C 2D FD 38 38 AB
    // 01
    // 00
    // 58 40 D4 32 0B 1D 68 49 E3 09 21 9D 30 03 7E 13 81 66 F2 50 82 47 DD
    // DA E7 6C CE EA 55 05 3C 10 8E 90 D5 51 F6 D6 01 06 F1 AB B4 84 CF BE
    // 62 56 C1 78 E4 AC 33 14 EA 19 19 1E 8B 60 7D A5 AE 3B DA 16

    pub(crate) fn tbs() -> TbsCert {
        fn extensions() -> Extensions {
            let mut exts = Extensions::new();
            exts.add_ext(Extension::new(
                oid!(2.5.29 .15),
                ExtensionValue::Int(1),
                false,
            ));
            exts
        }

        TbsCert::new(
            1,
            UnwrappedBigUint::new(128_269),
            name_cn_text().0,
            Time::new(1_672_531_200),
            Time::new(1_767_225_600),
            name_cn_eui_mac().0,
            SubjectPubKeyAlgorithm::new(oid!(1.2.840 .10045 .2 .1), None),
            PUBKEY.to_vec(),
            extensions(),
            IssuerSignatureAlgorithm::new(oid!(1.2.840 .10045 .4 .3 .2), None),
        )
    }

    #[test]
    fn encode_decode_tbs_cert() {
        let tbs_cert = tbs();

        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        tbs_cert
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode TBS Certificate");

        // c509_certificate_type: 0x01
        // certificate_serial_number: 0x4301f50d
        // issuer: 0x6b5246432074657374204341
        // validity_not_before: 0x1a63b0cd00
        // validity_not_after: 0x1a6955b900
        // subject: 0x47010123456789ab
        // subject_public_key_algorithm: 0x01
        // subject_public_key: 0x4888d0b6b0b37baa46
        // extensions: 0x01
        // issuer_signature_algorithm: 0x00

        assert_eq!(
            hex::encode(buffer.clone()),
            "014301f50d6b52464320746573742043411a63b0cd001a6955b90047010123456789ab014888d0b6b0b37baa460100"
        );

        let mut decoder = Decoder::new(&buffer);
        let decoded_tbs =
            TbsCert::decode(&mut decoder, &mut ()).expect("Failed to decode TBS Certificate");
        assert_eq!(decoded_tbs, tbs_cert);
    }

    // Test reference https://datatracker.ietf.org/doc/draft-ietf-cose-cbor-encoded-cert/09/
    // A.2.  Example IEEE 802.1AR profiled X.509 Certificate
    //
    // Certificate:
    // Data:
    // Version: 3 (0x2)
    // Serial Number: 9112578475118446130 (0x7e7661d7b54e4632)
    // Signature Algorithm: ecdsa-with-SHA256
    // Issuer: C=US, ST=CA, O=Example Inc, OU=certification, CN=802.1AR CA
    // Validity
    // Not Before: Jan 31 11:29:16 2019 GMT
    // Not After : Dec 31 23:59:59 9999 GMT
    // Subject: C=US, ST=CA, L=LA, O=example Inc, OU=IoT/serialNumber=Wt1234
    // Subject Public Key Info:
    // Public Key Algorithm: id-ecPublicKey
    // Public-Key: (256 bit)
    // pub:
    // 04:c8:b4:21:f1:1c:25:e4:7e:3a:c5:71:23:bf:2d:
    // 9f:dc:49:4f:02:8b:c3:51:cc:80:c0:3f:15:0b:f5:
    // 0c:ff:95:8d:75:41:9d:81:a6:a2:45:df:fa:e7:90:
    // be:95:cf:75:f6:02:f9:15:26:18:f8:16:a2:b2:3b:
    // 56:38:e5:9f:d9
    // ASN1 OID: prime256v1
    // NIST CURVE: P-256
    // X509v3 extensions:
    // X509v3 Basic Constraints:
    // CA:FALSE
    // X509v3 Subject Key Identifier:
    // 96:60:0D:87:16:BF:7F:D0:E7:52:D0:AC:76:07:77:AD:66:5D:02:A0
    // X509v3 Authority Key Identifier:
    // 68:D1:65:51:F9:51:BF:C8:2A:43:1D:0D:9F:08:BC:2D:20:5B:11:60
    // X509v3 Key Usage: critical
    // Digital Signature, Key Encipherment
    // X509v3 Subject Alternative Name:
    // otherName:
    // type-id: 1.3.6.1.5.5.7.8.4 (id-on-hardwareModuleName)
    // value:
    // hwType: 1.3.6.1.4.1.6175.10.1
    // hwSerialNum: 01:02:03:04
    // Signature Algorithm: ecdsa-with-SHA256
    // Signature Value:
    // 30:46:02:21:00:c0:d8:19:96:d2:50:7d:69:3f:3c:48:ea:a5:
    // ee:94:91:bd:a6:db:21:40:99:d9:81:17:c6:3b:36:13:74:cd:
    // 86:02:21:00:a7:74:98:9f:4c:32:1a:5c:f2:5d:83:2a:4d:33:
    // 6a:08:ad:67:df:20:f1:50:64:21:18:8a:0a:de:6d:34:92:36
    //
    // 01 48 7E 76 61 D7 B5 4E 46 32 8A 23 62 55 53 06 62 43 41 08 6B 45 78
    // 61 6D 70 6C 65 20 49 6E 63 09 6D 63 65 72 74 69 66 69 63 61 74 69 6F
    // 6E 01 6A 38 30 32 2E 31 41 52 20 43 41 1A 5C 52 DC 0C F6 8C 23 62 55
    // 53 06 62 43 41 05 62 4C 41 08 6B 65 78 61 6D 70 6C 65 20 49 6E 63 09
    // 63 49 6F 54 22 66 57 74 31 32 33 34 01 58 21 03 C8 B4 21 F1 1C 25 E4
    // 7E 3A C5 71 23 BF 2D 9F DC 49 4F 02 8B C3 51 CC 80 C0 3F 15 0B F5 0C
    // FF 95 8A 04 21 01 54 96 60 0D 87 16 BF 7F D0 E7 52 D0 AC 76 07 77 AD
    // 66 5D 02 A0 07 54 68 D1 65 51 F9 51 BF C8 2A 43 1D 0D 9F 08 BC 2D 20
    // 5B 11 60 21 05 03 82 20 82 49 2B 06 01 04 01 B0 1F 0A 01 44 01 02 03
    // 04 00 58 40 C0 D8 19 96 D2 50 7D 69 3F 3C 48 EA A5 EE 94 91 BD A6 DB
    // 21 40 99 D9 81 17 C6 3B 36 13 74 CD 86 A7 74 98 9F 4C 32 1A 5C F2 5D
    // 83 2A 4D 33 6A 08 AD 67 DF 20 F1 50 64 21 18 8A 0A DE 6D 34 92 36

    #[test]
    fn tbs_cert2() {
        // ---------helper----------
        // C=US, ST=CA, L=LA, O=example Inc, OU=IoT/serialNumber=Wt1234
        fn subject() -> Name {
            let mut attr1 = Attribute::new(oid!(2.5.4 .6));
            attr1.add_value(AttributeValue::Text("US".to_string()));
            let mut attr2 = Attribute::new(oid!(2.5.4 .8));
            attr2.add_value(AttributeValue::Text("CA".to_string()));
            let mut attr3 = Attribute::new(oid!(2.5.4 .7));
            attr3.add_value(AttributeValue::Text("LA".to_string()));
            let mut attr4 = Attribute::new(oid!(2.5.4 .10));
            attr4.add_value(AttributeValue::Text("example Inc".to_string()));
            let mut attr5 = Attribute::new(oid!(2.5.4 .11));
            attr5.add_value(AttributeValue::Text("IoT".to_string()));
            let mut attr6 = Attribute::new(oid!(2.5.4 .5));
            attr6.add_value(AttributeValue::Text("Wt1234".to_string()));

            let mut rdn = RelativeDistinguishedName::new();
            rdn.add_attr(attr1);
            rdn.add_attr(attr2);
            rdn.add_attr(attr3);
            rdn.add_attr(attr4);
            rdn.add_attr(attr5);
            rdn.add_attr(attr6);

            Name::new(NameValue::RelativeDistinguishedName(rdn))
        }

        fn extensions() -> Extensions {
            let mut exts = Extensions::new();
            exts.add_ext(Extension::new(
                oid!(2.5.29 .19),
                ExtensionValue::Int(-2),
                false,
            ));
            exts.add_ext(Extension::new(
                oid!(2.5.29 .14),
                ExtensionValue::Bytes(
                    [
                        0x96, 0x60, 0x0D, 0x87, 0x16, 0xBF, 0x7F, 0xD0, 0xE7, 0x52, 0xD0, 0xAC,
                        0x76, 0x07, 0x77, 0xAD, 0x66, 0x5D, 0x02, 0xA0,
                    ]
                    .to_vec(),
                ),
                false,
            ));
            exts.add_ext(Extension::new(
                oid!(2.5.29 .15),
                ExtensionValue::Int(5),
                true,
            ));
            let mut gns = GeneralNames::new();
            let hw = OtherNameHardwareModuleName::new(oid!(1.3.6 .1 .4 .1 .6175 .10 .1), vec![
                0x01, 0x02, 0x03, 0x04,
            ]);
            gns.add_gn(GeneralName::new(
                GeneralNameTypeRegistry::OtherNameHardwareModuleName,
                GeneralNameValue::OtherNameHWModuleName(hw),
            ));

            exts.add_ext(Extension::new(
                oid!(2.5.29 .17),
                ExtensionValue::AlternativeName(AlternativeName::new(
                    GeneralNamesOrText::GeneralNames(gns),
                )),
                false,
            ));

            exts
        }

        let tbs_cert = TbsCert::new(
            1,
            UnwrappedBigUint::new(9_112_578_475_118_446_130),
            names().0,
            Time::new(1_548_934_156),
            Time::new(253_402_300_799),
            subject(),
            SubjectPubKeyAlgorithm::new(oid!(1.2.840 .10045 .2 .1), None),
            PUBKEY.to_vec(),
            extensions(),
            IssuerSignatureAlgorithm::new(oid!(1.2.840 .10045 .4 .3 .2), None),
        );

        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        tbs_cert
            .encode(&mut encoder, &mut ())
            .expect("Failed to encode TBS Certificate");
        // c509_certificate_type: 0x01
        // certificate_serial_number: 0x487e7661d7b54e4632
        // issuer: 0x8a0462555306624341086b4578616d706c6520496e63096d63657274696669636174696f6e016a3830322e314152204341
        // validity_not_before: 0x1a5c52dc0c
        // validity_not_after: 0xf6
        // subject: 0x8c046255530662434105624c41086b6578616d706c6520496e630963496f540366577431323334
        // subject_public_key_algorithm: 0x01
        // subject_public_key: 0x4888d0b6b0b37baa46
        // extensions:
        // 0x840421015496600d8716bf7fd0e752d0ac760777ad665d02a0210503822082492b06010401b01f0a014401020304
        // issuer_signature_algorithm: 0x00
        assert_eq!(hex::encode(buffer.clone()), "01487e7661d7b54e46328a0462555306624341086b4578616d706c6520496e63096d63657274696669636174696f6e016a3830322e3141522043411a5c52dc0cf68c046255530662434105624c41086b6578616d706c6520496e630963496f540366577431323334014888d0b6b0b37baa46840421015496600d8716bf7fd0e752d0ac760777ad665d02a0210503822082492b06010401b01f0a01440102030400");
        let mut decoder = Decoder::new(&buffer);
        let decoded_tbs =
            TbsCert::decode(&mut decoder, &mut ()).expect("Failed to decode TBS Certificate");
        assert_eq!(decoded_tbs, tbs_cert);
    }
}
