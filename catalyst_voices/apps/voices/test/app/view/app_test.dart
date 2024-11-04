import 'package:catalyst_voices/pages/coming_soon/coming_soon_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('placeholder_test', (tester) async {
    await tester.pumpApp(const ComingSoonPage());
    await tester.pumpAndSettle();
  });
}
