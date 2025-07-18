enum VoicesProgressIndicatorWeight {
  medium,
  heavy;

  double get minHeight => switch (this) {
        VoicesProgressIndicatorWeight.medium => 5,
        VoicesProgressIndicatorWeight.heavy => 10,
      };
}
