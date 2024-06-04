import 'common.dart';

void main() {
  patrol('Test Landing page', (PatrolIntegrationTester $) async {
    await createApp($);
    await Future<void>.delayed(const Duration(seconds: 15));
    expect(
      $("""
Project Catalyst is the world's largest decentralized innovation engine for solving real-world challenges."""),
      findsOneWidget,
    );
    expect($('Coming'), findsOneWidget);
  });
}
