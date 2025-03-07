/// Main spaces between which user can navigate.
enum Space {
  discovery,
  workspace,
  voting,
  fundedProjects,
  treasury;

  // ignore: avoid_positional_boolean_parameters
  static List<Space> spaces(bool isAdmin) {
    if (isAdmin) return Space.values;
    return Space.values.sublist(0, 4);
  }
}
