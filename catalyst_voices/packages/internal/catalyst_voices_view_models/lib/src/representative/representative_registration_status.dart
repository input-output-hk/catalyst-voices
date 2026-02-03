enum RepresentativeRegistrationStatus {
  notRegistered,
  registered;

  const RepresentativeRegistrationStatus();

  factory RepresentativeRegistrationStatus.from({required bool isRegistered}) {
    return isRegistered
        ? RepresentativeRegistrationStatus.registered
        : RepresentativeRegistrationStatus.notRegistered;
  }

  bool get isRegistered => this == RepresentativeRegistrationStatus.registered;
}
