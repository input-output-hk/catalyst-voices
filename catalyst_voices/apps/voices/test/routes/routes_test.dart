import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  /// See https://github.com/input-output-hk/catalyst-internal-docs/issues/178
  test('backends path is not used in any of pages', () {
    // Given
    final routes = Routes.routes;
    const backendsPath = 'api';

    // When
    final allRoutes = RouteBase.routesRecursively(routes);
    final paths = allRoutes.whereType<GoRoute>().map((e) => e.path).toList();

    // Then
    expect(
      paths,
      isNot(anyElement(contains(backendsPath))),
      reason: 'api path is reserved for backends',
    );
  });
}
