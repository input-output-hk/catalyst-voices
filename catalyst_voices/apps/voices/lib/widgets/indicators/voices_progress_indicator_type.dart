enum VoicesProgressIndicatorType {
  medium,
  heavy;

  double get minHeight => switch (this) {
        VoicesProgressIndicatorType.medium => 5,
        VoicesProgressIndicatorType.heavy => 10,
      };
}
