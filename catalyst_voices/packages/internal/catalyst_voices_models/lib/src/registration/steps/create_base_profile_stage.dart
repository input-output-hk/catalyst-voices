/// Describes the base profile creation during registration.
enum CreateBaseProfileStage {
  /// Givens context to user about what is seed phrase.
  instructions,

  /// User inputs base profile data here. (email and display name).
  setup,

  /// Checkboxes with mandatory acknowledgements.
  acknowledgements;

  CreateBaseProfileStage? get next {
    final isLast = index == CreateBaseProfileStage.values.length - 1;
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
