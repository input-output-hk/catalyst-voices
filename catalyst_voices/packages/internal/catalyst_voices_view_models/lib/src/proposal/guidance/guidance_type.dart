enum GuidanceType { mandatory, education, tips }

extension GuidanceTypeExt on GuidanceType {
  int get priority {
    return switch (this) {
      GuidanceType.mandatory => 0, // Highest priority
      GuidanceType.education => 1,
      GuidanceType.tips => 2, // Lowest priority
    };
  }
}
