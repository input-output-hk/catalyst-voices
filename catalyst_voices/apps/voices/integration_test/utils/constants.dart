enum Time {
  veryShort(Duration(milliseconds: 500)),
  short(Duration(seconds: 2)),
  long(Duration(minutes: 10));

  final Duration duration;

  const Time(this.duration);
}

class Urls {
  static String urlTos =
      'https://docs.projectcatalyst.io/current-fund/fund-basics/project-catalyst-terms-and-conditions';
  static String urlPrivacyPolicy =
      'https://docs.projectcatalyst.io/current-fund/fund-basics/project-catalyst-terms-and-conditions/catalyst-fc-privacy-policy';
}
