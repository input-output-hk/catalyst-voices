import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:equatable/equatable.dart';

bool _registeredASN1Names = false;

/// Before we can interact with the asn1lib we must register frequent names,
/// however there's no single entry point to catalyst_cardano_serialization
/// and we must expect different starting points. Therefore we call the method
/// to register these names each time we need to interact with the asn1lib.
void _ensureASN1FrequentNamesRegistered() {
  if (!_registeredASN1Names) {
    _registerASN1FrequentNames();
  }
}

void _registerASN1FrequentNames() {
  ASN1ObjectIdentifier.registerFrequentNames();
  _registeredASN1Names = true;
}

/// Represents the X509 encoded certificate.
class X509Certificate with EquatableMixin {
  /// The ToBeSigned certificate with details.
  final X509TBSCertificate tbsCertificate;

  /// The signature of a signed [tbsCertificate].
  final Uint8List signature;

  /// The default constructor for [X509Certificate].
  const X509Certificate({
    required this.tbsCertificate,
    required this.signature,
  });

  /// Generates a self-signed [X509Certificate] from [tbsCertificate]
  /// that is signed using the [privateKey].
  static Future<X509Certificate> generateSelfSigned({
    required X509TBSCertificate tbsCertificate,
    required Ed25519ExtendedPrivateKey privateKey,
  }) async {
    final encodedTbsCertificate = tbsCertificate.toASN1();
    final signature = await privateKey.sign(encodedTbsCertificate.encodedBytes);

    return X509Certificate(
      tbsCertificate: tbsCertificate,
      signature: Uint8List.fromList(signature.bytes),
    );
  }

  /// Encodes the data in ASN1 format.
  ASN1Object toASN1() {
    _ensureASN1FrequentNamesRegistered();

    return ASN1Sequence()
      ..add(tbsCertificate.toASN1())
      ..add(tbsCertificate._createSignatureAlgorithm())
      ..add(ASN1BitString(signature));
  }

  /// Encodes the data in DER format.
  X509DerCertificate toDer() {
    return X509DerCertificate.fromBytes(bytes: toASN1().encodedBytes);
  }

  /// Converts the certificate to PEM format, uses [label]
  /// as the certificate header.
  String toPem([String label = 'CERTIFICATE']) {
    final derBytes = toASN1().encodedBytes;
    final base64 = base64Encode(derBytes);
    final chunks =
        RegExp('.{1,64}').allMatches(base64).map((m) => m.group(0)).join('\n');

    return '-----BEGIN $label-----\n'
        '$chunks\n'
        '-----END $label-----';
  }

  @override
  List<Object?> get props => [tbsCertificate, signature];
}

/// The ToBeSigned X509 certificate, contains the details about
/// the [subject] and [issuer] of the certificate.
///
/// In case of a self-signed certificate the [issuer] will
/// be the same as [subject].
class X509TBSCertificate with EquatableMixin {
  /// A [DateTime] that can be used as [validityNotAfter]
  /// to represent a certificate which never expires.
  static final DateTime foreverValid = DateTime.utc(9999, 12, 31, 23, 59, 59);

  /// The version of the certificate, the latest one is v3
  /// (int value = 2).
  final int version;

  /// The unique serial number of the certificate.
  /// A simple integer consisting of up to 20 bytes.
  final int serialNumber;

  /// The issuer of the certificate.
  /// In case of self-signed it's the same as [subject].
  final X509DistinguishedName issuer;

  /// The timestamp which specifies from when the certificate is valid.
  final DateTime validityNotBefore;

  /// The timestamp which specifies until when the certificate is valid.
  final DateTime validityNotAfter;

  /// The subject of the certificate.
  ///
  /// In case of self-signed it's the same as [issuer].
  final X509DistinguishedName subject;

  /// The public key of the [subject].
  final Ed25519ExtendedPublicKey subjectPublicKey;

  /// Extra extensions of the certificate.
  final X509CertificateExtensions? extensions;

  /// The default constructor for [X509TBSCertificate].
  const X509TBSCertificate({
    this.version = 2,
    required this.serialNumber,
    required this.subjectPublicKey,
    required this.issuer,
    required this.validityNotBefore,
    required this.validityNotAfter,
    required this.subject,
    this.extensions,
  });

  /// Encodes the data in ASN1 format.
  ASN1Object toASN1() {
    _ensureASN1FrequentNamesRegistered();

    final sequence = ASN1Sequence()
      ..add(_createVersion(version))
      ..add(_createSerialNumber(serialNumber))
      ..add(_createSignatureAlgorithm())
      ..add(issuer.toASN1())
      ..add(_createValidity())
      ..add(subject.toASN1())
      ..add(_createSubjectPublicKeyInfo(subjectPublicKey));

    final extensions = this.extensions;
    if (extensions != null) {
      sequence.add(extensions.toASN1());
    }

    return sequence;
  }

  ASN1Object _createVersion(int version) {
    return ASN1Sequence(tag: 0xA0)..add(ASN1Integer(BigInt.from(version)));
  }

  ASN1Object _createSerialNumber(int serialNumber) {
    return ASN1Integer(BigInt.from(serialNumber));
  }

  ASN1Object _createSignatureAlgorithm() {
    /* cSpell:disable */
    ASN1ObjectIdentifier.registerObjectIdentiferName(
      'Ed25519',
      ASN1ObjectIdentifier.fromComponentString('1.3.101.112'),
    );
    /* cSpell:enable */

    return ASN1Sequence()..add(ASN1ObjectIdentifier.fromName('Ed25519'));
  }

  ASN1Object _createValidity() {
    // Validity (not before and not after)
    return ASN1Sequence()
      ..add(ASN1UtcTime(validityNotBefore.toUtc()))
      ..add(ASN1UtcTime(validityNotAfter.toUtc()));
  }

  ASN1Object _createSubjectPublicKeyInfo(Ed25519ExtendedPublicKey publicKey) {
    return ASN1Sequence()
      ..add(
        ASN1Sequence()
          ..add(
            ASN1ObjectIdentifier.fromName('Ed25519'),
          ),
      )
      ..add(ASN1BitString(publicKey.bytes));
  }

  @override
  List<Object?> get props => [
        version,
        serialNumber,
        subjectPublicKey,
        issuer,
        validityNotBefore,
        validityNotAfter,
        subject,
        extensions,
      ];
}

/// The structure describing the [X509TBSCertificate.issuer] / [X509TBSCertificate.subject].
class X509DistinguishedName with EquatableMixin {
  /// The country name as country code, i.e. "US".
  final String? countryName;

  /// The state or province, i.e. California.
  final String? stateOrProvinceName;

  /// The location (city), i.e. San Francisco.
  final String? localityName;

  /// The organization (foundation, company, etc).
  final String? organizationName;

  /// The unit name in the organization (i.e. department of a company/foundation).
  final String? organizationalUnitName;

  /// The entity name (domain name or individual's name).
  final String? commonName;

  /// The default constructor for [X509DistinguishedName].
  const X509DistinguishedName({
    this.countryName,
    this.stateOrProvinceName,
    this.localityName,
    this.organizationName,
    this.organizationalUnitName,
    this.commonName,
  });

  /// Encodes the data in ASN1 format.
  ASN1Object toASN1() {
    _ensureASN1FrequentNamesRegistered();

    final sequence = ASN1Sequence();

    final countryName = this.countryName;
    if (countryName != null) {
      sequence.add(
        ASN1Sequence()
          ..add(ASN1ObjectIdentifier.fromName('c'))
          ..add(ASN1PrintableString(countryName)),
      );
    }

    final stateOrProvinceName = this.stateOrProvinceName;
    if (stateOrProvinceName != null) {
      sequence.add(
        ASN1Sequence()
          ..add(ASN1ObjectIdentifier.fromName('st'))
          ..add(ASN1PrintableString(stateOrProvinceName)),
      );
    }

    final localityName = this.localityName;
    if (localityName != null) {
      sequence.add(
        ASN1Sequence()
          ..add(ASN1ObjectIdentifier.fromName('l'))
          ..add(ASN1PrintableString(localityName)),
      );
    }

    final organizationName = this.organizationName;
    if (organizationName != null) {
      sequence.add(
        ASN1Sequence()
          ..add(ASN1ObjectIdentifier.fromName('o'))
          ..add(ASN1PrintableString(organizationName)),
      );
    }

    final organizationalUnitName = this.organizationalUnitName;
    if (organizationalUnitName != null) {
      sequence.add(
        ASN1Sequence()
          ..add(ASN1ObjectIdentifier.fromName('ou'))
          ..add(ASN1PrintableString(organizationalUnitName)),
      );
    }

    final commonName = this.commonName;
    if (commonName != null) {
      sequence.add(
        ASN1Sequence()
          ..add(ASN1ObjectIdentifier.fromName('cn'))
          ..add(ASN1PrintableString(commonName)),
      );
    }

    return sequence;
  }

  @override
  List<Object?> get props => [
        countryName,
        stateOrProvinceName,
        localityName,
        organizationName,
        organizationalUnitName,
        commonName,
      ];
}

/// Extra extensions of the certificate.
class X509CertificateExtensions with EquatableMixin {
  /// List of alternative subject names.
  final List<String>? subjectAltName;

  /// The default constructor for the [X509CertificateExtensions].
  const X509CertificateExtensions({this.subjectAltName});

  /// Encodes the data in ASN1 format.
  ASN1Object toASN1() {
    _ensureASN1FrequentNamesRegistered();

    final sequence = ASN1Sequence(tag: 0xA3);
    final extensionsSequence = ASN1Sequence();
    sequence.add(extensionsSequence);

    final subjectAltName = this.subjectAltName;
    if (subjectAltName != null) {
      final subjectAltNameSequence = ASN1Sequence();
      for (final name in subjectAltName) {
        subjectAltNameSequence.add(ASN1OctetString(name));
      }

      extensionsSequence.add(
        ASN1Sequence()
          ..add(ASN1ObjectIdentifier.fromName('subjectAltName'))
          ..add(ASN1OctetString(subjectAltNameSequence.encodedBytes)),
      );
    }

    if (extensionsSequence.elements.isEmpty) {
      return ASN1Null();
    }

    return sequence;
  }

  @override
  List<Object?> get props => [subjectAltName];
}
