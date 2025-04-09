enum Time {
  veryShort(Duration(milliseconds: 500)),
  short(Duration(seconds: 2)),
  long(Duration(minutes: 10));

  final Duration duration;

  const Time(this.duration);
}

class Urls {
  static String tos =
      'https://docs.projectcatalyst.io/current-fund/fund-basics/project-catalyst-terms-and-conditions';
  static String privacyPolicy =
      'https://docs.projectcatalyst.io/current-fund/fund-basics/project-catalyst-terms-and-conditions/catalyst-fc-privacy-policy';
  static String supportedWallets =
      'https://docs.projectcatalyst.io/current-fund/voter-registration/supported-wallets';
}
