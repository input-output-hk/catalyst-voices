import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' hide Ed25519PublicKey;
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

  /// Decodes the [X509Certificate] from [ASN1Object]
  /// obtained from calling [toASN1].
  factory X509Certificate.fromASN1(ASN1Object object) {
    _ensureASN1FrequentNamesRegistered();

    final sequence = object.asSequence;
    final tbsCertificateASN1 = sequence.elements[0];
    final signatureASN1 = sequence.elements[2] as ASN1BitString;

    return X509Certificate(
      tbsCertificate: X509TBSCertificate.fromASN1(tbsCertificateASN1),
      signature: signatureASN1.contentBytes(),
    );
  }

  /// Decodes the [X509Certificate] from [X509DerCertificate].
  factory X509Certificate.fromDer(X509DerCertificate certificate) {
    _ensureASN1FrequentNamesRegistered();

    final bytes = Uint8List.fromList(certificate.bytes);
    final asn1 = ASN1Sequence.fromBytes(bytes);
    return X509Certificate.fromASN1(asn1);
  }

  /// Decodes the [X509Certificate] from PEM format string.
  factory X509Certificate.fromPem(String pem) {
    final pemData = extractBase64FromPem(pem);
    final certificateBytes = base64Decode(pemData);
    final derCertificate = X509DerCertificate.fromBytes(bytes: certificateBytes);
    return X509Certificate.fromDer(derCertificate);
  }

  @override
  List<Object?> get props => [tbsCertificate, signature];

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
    final chunks = RegExp('.{1,64}').allMatches(base64).map((m) => m.group(0)).join('\n');

    return '-----BEGIN $label-----\n'
        '$chunks\n'
        '-----END $label-----';
  }

  /// Extracts Base64 data from PEM format by removing formatting elements.
  ///
  /// Removes the following:
  /// - `-----BEGIN [LABEL]-----` headers (e.g., `-----BEGIN CERTIFICATE-----`)
  /// - `-----END [LABEL]-----` footers (e.g., `-----END CERTIFICATE-----`)
  /// - `-----BEGIN-----` headers without labels
  /// - `-----END-----` footers without labels
  /// - All whitespace characters (spaces, tabs, newlines, carriage returns)
  ///
  /// Returns the raw Base64-encoded string without any formatting.
  static String extractBase64FromPem(String pem) {
    return pem.replaceAll(RegExp(r'-----(?:BEGIN|END)\s*[^-]*-----|\s+'), '');
  }

  /// Generates a self-signed [X509Certificate] from [tbsCertificate]
  /// that is signed using the [privateKey].
  static Future<X509Certificate> generateSelfSigned({
    required X509TBSCertificate tbsCertificate,
    required Bip32Ed25519XPrivateKey privateKey,
  }) async {
    final encodedTbsCertificate = tbsCertificate.toASN1();
    final signature = await privateKey.sign(encodedTbsCertificate.encodedBytes);

    return X509Certificate(
      tbsCertificate: tbsCertificate,
      signature: Uint8List.fromList(signature.bytes),
    );
  }
}

/// Extra extensions of the certificate.
class X509CertificateExtensions with EquatableMixin {
  /// List of alternative subject names.
  final List<X509String>? subjectAltName;

  /// The default constructor for the [X509CertificateExtensions].
  const X509CertificateExtensions({this.subjectAltName});

  /// Decodes the [X509CertificateExtensions] from [ASN1Object]
  /// obtained from calling [toASN1].
  factory X509CertificateExtensions.fromASN1(ASN1Object object) {
    _ensureASN1FrequentNamesRegistered();

    if (object is ASN1Null) {
      return const X509CertificateExtensions();
    }

    final sequence = object.asSequence;
    final extensionsSequence = sequence.elements.first.asSequence;
    final subjectAltNameSequence = extensionsSequence.elements.first.asSequence;
    final subjectAltNameIdentifier = subjectAltNameSequence.elements[0] as ASN1ObjectIdentifier;

    if (subjectAltNameIdentifier != ASN1ObjectIdentifier.fromName('subjectAltName')) {
      return const X509CertificateExtensions();
    }

    final subjectAltNameOctetString = subjectAltNameSequence.elements[1].asOctetString;

    final subjectAltNameElementsSequence = ASN1Sequence.fromBytes(
      subjectAltNameOctetString.valueBytes(),
    );

    final subjectAltName = <X509String>[];
    for (final element in subjectAltNameElementsSequence.elements) {
      subjectAltName.add(X509String.fromASN1(element));
    }

    return X509CertificateExtensions(subjectAltName: subjectAltName);
  }

  @override
  List<Object?> get props => [subjectAltName];

  /// Encodes the data in ASN1 format.
  ASN1Object toASN1() {
    _ensureASN1FrequentNamesRegistered();

    final sequence = ASN1Sequence(tag: 0xA3);
    final extensionsSequence = ASN1Sequence();
    sequence.add(extensionsSequence);

    final subjectAltName = this.subjectAltName;
    if (subjectAltName == null) {
      return ASN1Null();
    }

    final subjectAltNameSequence = ASN1Sequence();
    for (final name in subjectAltName) {
      subjectAltNameSequence.add(name.toASN1());
    }

    extensionsSequence.add(
      ASN1Sequence()
        ..add(ASN1ObjectIdentifier.fromName('subjectAltName'))
        ..add(ASN1OctetString(subjectAltNameSequence.encodedBytes)),
    );

    if (extensionsSequence.elements.isEmpty) {
      return ASN1Null();
    }

    return sequence;
  }
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

  /// Decodes the [X509DistinguishedName] from [ASN1Object]
  /// obtained from calling [toASN1].
  factory X509DistinguishedName.fromASN1(ASN1Object object) {
    _ensureASN1FrequentNamesRegistered();

    final sequence = object.asSequence;

    return X509DistinguishedName(
      countryName: _findString(sequence, 'c'),
      stateOrProvinceName: _findString(sequence, 'st'),
      localityName: _findString(sequence, 'l'),
      organizationName: _findString(sequence, 'o'),
      organizationalUnitName: _findString(sequence, 'ou'),
      commonName: _findString(sequence, 'cn'),
    );
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

  /// Encodes the data in ASN1 format.
  ASN1Object toASN1() {
    _ensureASN1FrequentNamesRegistered();

    final sequence = ASN1Sequence();

    final countryName = this.countryName;
    if (countryName != null) {
      sequence.add(_createCountryName(countryName));
    }

    final stateOrProvinceName = this.stateOrProvinceName;
    if (stateOrProvinceName != null) {
      sequence.add(_createStateOrProvinceName(stateOrProvinceName));
    }

    final localityName = this.localityName;
    if (localityName != null) {
      sequence.add(_createLocalityName(localityName));
    }

    final organizationName = this.organizationName;
    if (organizationName != null) {
      sequence.add(_createOrganizationName(organizationName));
    }

    final organizationalUnitName = this.organizationalUnitName;
    if (organizationalUnitName != null) {
      sequence.add(_createOrganizationalUnitName(organizationalUnitName));
    }

    final commonName = this.commonName;
    if (commonName != null) {
      sequence.add(_createCommonName(commonName));
    }

    return sequence;
  }

  ASN1Object _createCommonName(String commonName) {
    return ASN1Set()..add(
      ASN1Sequence()
        ..add(ASN1ObjectIdentifier.fromName('cn'))
        ..add(ASN1PrintableString(commonName)),
    );
  }

  ASN1Object _createCountryName(String countryName) {
    return ASN1Set()..add(
      ASN1Sequence()
        ..add(ASN1ObjectIdentifier.fromName('c'))
        ..add(ASN1PrintableString(countryName)),
    );
  }

  ASN1Object _createLocalityName(String localityName) {
    return ASN1Set()..add(
      ASN1Sequence()
        ..add(ASN1ObjectIdentifier.fromName('l'))
        ..add(ASN1PrintableString(localityName)),
    );
  }

  ASN1Object _createOrganizationalUnitName(String organizationalUnitName) {
    return ASN1Set()..add(
      ASN1Sequence()
        ..add(ASN1ObjectIdentifier.fromName('ou'))
        ..add(ASN1PrintableString(organizationalUnitName)),
    );
  }

  ASN1Object _createOrganizationName(String organizationName) {
    return ASN1Set()..add(
      ASN1Sequence()
        ..add(ASN1ObjectIdentifier.fromName('o'))
        ..add(ASN1PrintableString(organizationName)),
    );
  }

  ASN1Object _createStateOrProvinceName(String stateOrProvinceName) {
    return ASN1Set()..add(
      ASN1Sequence()
        ..add(ASN1ObjectIdentifier.fromName('st'))
        ..add(ASN1PrintableString(stateOrProvinceName)),
    );
  }

  static String? _findString(ASN1Sequence sequence, String name) {
    for (final element in sequence.elements) {
      final set = element.asSet;
      final childSequence = set.elements.first.asSequence;
      final identifier = childSequence.elements[0] as ASN1ObjectIdentifier;
      final value = childSequence.elements[1] as ASN1PrintableString;

      if (identifier == ASN1ObjectIdentifier.fromName(name)) {
        return value.stringValue;
      }
    }

    return null;
  }
}

/// Represents an ASN1 encodable string
/// that can be optionally tagged with [tag].
class X509String with EquatableMixin {
  /// An ASN1 tag for the uris.
  static const int uriTag = 0x86;

  /// An ASN1 tag for domain names.
  static const int domainNameTag = 0x82;

  /// The string value.
  final String value;

  /// The optional ASN1 tag.
  final int tag;

  /// The default constructor for the [X509String].
  const X509String(
    this.value, {
    this.tag = OCTET_STRING_TYPE,
  });

  /// Decodes the [X509String] from [ASN1Object]
  /// obtained from calling [toASN1].
  factory X509String.fromASN1(ASN1Object object) {
    _ensureASN1FrequentNamesRegistered();

    final string = object.asOctetString;
    return X509String(
      string.stringValue,
      tag: string.tag,
    );
  }

  @override
  List<Object?> get props => [value, tag];

  /// Encodes the data in ASN1 format.
  ASN1Object toASN1() {
    _ensureASN1FrequentNamesRegistered();

    return ASN1OctetString(value, tag: tag);
  }
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
  final Ed25519PublicKey subjectPublicKey;

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

  /// Decodes the [X509TBSCertificate] from [ASN1Object]
  /// obtained from calling [toASN1].
  factory X509TBSCertificate.fromASN1(ASN1Object object) {
    _ensureASN1FrequentNamesRegistered();

    final sequence = object.asSequence;
    final versionASN1 = sequence.elements[0];
    final serialNumberASN1 = sequence.elements[1];
    final issuerASN1 = sequence.elements[3];
    final validityASN1 = sequence.elements[4].asSequence;
    final subjectASN1 = sequence.elements[5];
    final subjectPublicKeyASN1 = sequence.elements[6];
    final extensionsASN1 = sequence.elements.elementAtOrNull(7);

    // validity
    final validityNotBeforeASN1 = validityASN1.elements[0];
    final validityNotAfterASN1 = validityASN1.elements[1];

    return X509TBSCertificate(
      version: _readVersion(versionASN1),
      serialNumber: _readSerialNumber(serialNumberASN1),
      issuer: X509DistinguishedName.fromASN1(issuerASN1),
      validityNotBefore: validityNotBeforeASN1.asDateTime,
      validityNotAfter: validityNotAfterASN1.asDateTime,
      subject: X509DistinguishedName.fromASN1(subjectASN1),
      subjectPublicKey: _readSubjectPublicKeyInfo(subjectPublicKeyASN1),
      extensions: extensionsASN1 != null
          ? X509CertificateExtensions.fromASN1(extensionsASN1)
          : null,
    );
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
      ..add(_createSubjectPublicKeyInfo());

    final extensions = this.extensions;
    if (extensions != null) {
      sequence.add(extensions.toASN1());
    }

    return sequence;
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

  ASN1Object _createSubjectPublicKeyInfo() {
    return ASN1Sequence()
      ..add(
        ASN1Sequence()..add(
          ASN1ObjectIdentifier.fromName('Ed25519'),
        ),
      )
      ..add(ASN1BitString(subjectPublicKey.bytes));
  }

  ASN1Object _createValidity() {
    // Validity (not before and not after)
    return ASN1Sequence()
      ..add(ASN1GeneralizedTime(validityNotBefore.toUtc()))
      ..add(ASN1GeneralizedTime(validityNotAfter.toUtc()));
  }

  ASN1Object _createVersion(int version) {
    return ASN1Sequence(tag: 0xA0)..add(ASN1Integer(BigInt.from(version)));
  }

  static int _readSerialNumber(ASN1Object object) {
    final integer = object as ASN1Integer;
    return integer.intValue;
  }

  static Ed25519PublicKey _readSubjectPublicKeyInfo(ASN1Object object) {
    final sequence = object.asSequence;
    final string = sequence.elements[1] as ASN1BitString;
    final stringBytes = string.contentBytes();
    return Ed25519PublicKey.fromSimpleOrExtendedBytes(stringBytes);
  }

  static int _readVersion(ASN1Object object) {
    final sequence = object.asSequence;
    final integer = sequence.elements.first as ASN1Integer;
    return integer.intValue;
  }
}

extension on ASN1Object {
  DateTime get asDateTime {
    final object = this;
    if (object is ASN1GeneralizedTime) {
      return object.dateTimeValue;
    } else if (object is ASN1UtcTime) {
      return object.dateTimeValue;
    } else {
      throw ArgumentError.value(
        object,
        'object',
        'Is not an instance of any known DateTime format.',
      );
    }
  }

  ASN1OctetString get asOctetString {
    final object = this;
    if (object is ASN1OctetString) {
      return object;
    } else {
      return ASN1OctetString.fromBytes(object.encodedBytes);
    }
  }

  ASN1Sequence get asSequence {
    final object = this;
    if (object is ASN1Sequence) {
      return object;
    } else {
      return ASN1Sequence.fromBytes(object.encodedBytes);
    }
  }

  ASN1Set get asSet {
    final object = this;
    if (object is ASN1Set) {
      return object;
    } else {
      return ASN1Set.fromBytes(object.encodedBytes);
    }
  }
}
