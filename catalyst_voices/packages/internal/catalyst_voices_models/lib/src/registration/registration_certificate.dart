import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum CertificateType {
  pubkey('pubkey'),
  x509('x509'),
  c509('c509');

  final String value;

  const CertificateType(this.value);
}

/// Holds common constants about the certificates used in user registration.
final class RegistrationCertificate {
  /// The type of the certificate used in the registration.
  static const certificateType = CertificateType.x509;

  const RegistrationCertificate._();
}
