import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VoicesTextField Widget Tests', () {
    testWidgets('renders correctly with default parameters', (tester) async {
      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Verify the TextField is rendered
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('displays label text when provided', (tester) async {
      const labelText = 'Test Label';

      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            decoration: const VoicesTextFieldDecoration(labelText: labelText),
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Verify the label text is rendered
      expect(find.text(labelText), findsOneWidget);
    });

    testWidgets('handles text input and updates controller', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            controller: controller,
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Enter text into the TextField
      await tester.enterText(find.byType(TextFormField), 'Hello World');

      // Verify that the controller's text is updated
      expect(controller.text, 'Hello World');
    });

    testWidgets('applies custom decorations correctly', (tester) async {
      const hintText = 'Enter your text here';
      const errorText = 'Error message';

      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            decoration: const VoicesTextFieldDecoration(
              hintText: hintText,
              errorText: errorText,
            ),
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Verify that hint, helper, and error texts are applied
      expect(find.text(hintText), findsOneWidget);
      expect(find.text(errorText), findsOneWidget);
    });

    testWidgets('validates input and displays error correctly', (tester) async {
      const errorText = 'Invalid input';

      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            validator: (value) => const VoicesTextFieldValidationResult(
              status: VoicesTextFieldStatus.error,
              errorMessage: errorText,
            ),
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Enter invalid text into the TextField
      await tester.enterText(find.byType(TextFormField), 'Invalid');

      // Trigger validation by losing focus
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Verify that the error message is displayed
      expect(find.text(errorText), findsOneWidget);
    });

    testWidgets('displays correct suffix icon based on validation result',
        (tester) async {
      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            validator: (value) {
              return const VoicesTextFieldValidationResult.success();
            },
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Enter valid text into the TextField
      await tester.enterText(find.byType(TextFormField), 'Valid');
      await tester.pump();

      // Verify that the success icon is displayed
      expect(
        find.byType(CatalystSvgIcon),
        findsOneWidget,
      );
    });

    testWidgets('renders correctly when disabled', (tester) async {
      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            enabled: false,
            decoration: const VoicesTextFieldDecoration(
              labelText: 'Disabled TextField',
            ),
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Verify that the TextField is rendered as disabled
      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isFalse);
    });
  });

  group('VoicesTextField Validator Logic Tests', () {
    testWidgets('displays error when validation fails', (tester) async {
      const errorMessage = 'This field is required';

      // Define a validator that returns an error if the input is empty
      VoicesTextFieldValidationResult validator(String value) {
        if (value.isEmpty) {
          return const VoicesTextFieldValidationResult(
            status: VoicesTextFieldStatus.error,
            errorMessage: errorMessage,
          );
        }
        return const VoicesTextFieldValidationResult(
          status: VoicesTextFieldStatus.none,
        );
      }

      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            validator: validator,
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Enter empty text into the TextField to trigger validation
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      // Verify that the error message is displayed
      expect(find.text(errorMessage), findsOneWidget);

      // Enter valid text into the TextField
      await tester.enterText(find.byType(TextFormField), 'Valid input');
      await tester.pump();

      // Verify that the error message is no longer displayed
      expect(find.text(errorMessage), findsNothing);
    });

    testWidgets('displays success when validation passes', (tester) async {
      // Define a validator that always returns success
      VoicesTextFieldValidationResult validator(value) {
        return const VoicesTextFieldValidationResult(
          status: VoicesTextFieldStatus.success,
        );
      }

      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            validator: validator,
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Enter text into the TextField to trigger validation
      await tester.enterText(find.byType(TextFormField), 'Valid input');
      await tester.pump();

      // Verify that the success icon is displayed
      expect(
        find.byType(CatalystSvgIcon),
        findsOneWidget,
      );
    });

    testWidgets('displays warning when validation returns warning',
        (tester) async {
      const warningMessage = 'This is a warning';

      // Define a validator that returns a warning for specific input
      VoicesTextFieldValidationResult validator(String value) {
        if (value == 'warning') {
          return const VoicesTextFieldValidationResult(
            status: VoicesTextFieldStatus.warning,
            errorMessage: warningMessage,
          );
        }
        return const VoicesTextFieldValidationResult(
          status: VoicesTextFieldStatus.none,
        );
      }

      await tester.pumpWidget(
        _MaterialApp(
          child: VoicesTextField(
            validator: validator,
            onFieldSubmitted: (value) {},
          ),
        ),
      );

      // Enter the text that triggers a warning
      await tester.enterText(find.byType(TextFormField), 'warning');
      await tester.pump();

      // Verify that the warning message is displayed
      expect(find.text(warningMessage), findsOneWidget);

      // Verify that the warning icon is displayed
      expect(find.byIcon(Icons.warning_outlined), findsOneWidget);
    });
  });
}

class _MaterialApp extends StatelessWidget {
  final Widget child;

  const _MaterialApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeBuilder.buildTheme(brand: Brand.catalyst),
      home: Scaffold(body: child),
    );
  }
}
