/// An entity which represents markdown formatted data.
///
/// Its simple wrapper to enforce strong type instead of just using [String].
extension type const MarkdownData(String data) implements Object {
  /// An empty instance of [MarkdownData].
  static const MarkdownData empty = MarkdownData('');
}
