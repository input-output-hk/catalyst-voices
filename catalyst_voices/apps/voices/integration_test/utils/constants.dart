enum Time {
  veryShort(Duration(milliseconds: 500)),
  short(Duration(seconds: 2)),
  long(Duration(minutes: 10));

  final Duration duration;

  const Time(this.duration);
}
