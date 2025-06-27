/// Describes the base profile creation during registration.
enum CreateBaseProfileStage {
  /// Givens context to user about what it takes to create account and accept acknowledgements.
  instructions,

  /// User inputs base profile data here. (email and display name).
  setup;

  CreateBaseProfileStage? get next {
    final isLast = this == CreateBaseProfileStage.values.last;
    if (isLast) {
      return null;
    }

    return CreateBaseProfileStage.values[index + 1];
  }

  CreateBaseProfileStage? get previous {
    final isFirst = index == 0;
    if (isFirst) {
      return null;
    }

    return CreateBaseProfileStage.values[index - 1];
  }
}
