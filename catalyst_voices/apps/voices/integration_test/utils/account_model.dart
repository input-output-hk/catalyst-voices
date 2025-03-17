class Account {
  final String displayName;
  final String emailAddress;
  final String password;
  final List<String> seedPhrase;
  final String role;

  Account({
    required this.displayName,
    required this.emailAddress,
    required this.password,
    required this.seedPhrase,
    this.role = 'voter', // Default role is 'voter'
  });

  // Convert the account to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'emailAddress': emailAddress,
      'password': password,
      'seedPhrase': seedPhrase,
      'role': role,
    };
  }

  // Create an account from a JSON map
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      displayName: json['displayName'] as String,
      emailAddress: json['emailAddress'] as String,
      password: json['password'] as String,
      seedPhrase: (json['seedPhrase'] as List<dynamic>).cast<String>(),
      role: json['role'] as String? ?? 'voter',
    );
  }
}
