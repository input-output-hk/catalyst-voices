import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesTextFieldExample extends StatefulWidget {
  static const String route = '/text-field-example';

  const VoicesTextFieldExample({super.key});

  @override
  State<VoicesTextFieldExample> createState() => _VoicesTextFieldExampleState();
}

class _VoicesTextFieldExampleState extends State<VoicesTextFieldExample> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Text Field')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: VoicesTextFieldDecoration(
                  labelText: 'Regular',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                  suffixIcon: VoicesAssets.icons.chevronDown.buildIcon(),
                ),
                maxLength: 200,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: VoicesTextFieldDecoration(
                  labelText: 'Disabled',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                  suffixIcon: VoicesAssets.icons.chevronDown.buildIcon(),
                ),
                maxLength: 200,
                enabled: false,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Error text',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                  errorText: 'Error text',
                  suffixIcon: Icon(Icons.error_outline),
                ),
                maxLength: 200,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Success',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                ),
                maxLength: 200,
                validator: VoicesTextFieldValidationResult.success(),
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Warning',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                ),
                maxLength: 200,
                validator:
                    VoicesTextFieldValidationResult.warning('Warning message'),
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Error',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                ),
                maxLength: 200,
                validator:
                    VoicesTextFieldValidationResult.error('Error message'),
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Success / disabled',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                ),
                maxLength: 200,
                validator: VoicesTextFieldValidationResult.success(),
                enabled: false,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Warning / disabled',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                ),
                maxLength: 200,
                validator:
                    VoicesTextFieldValidationResult.warning('Warning message'),
                enabled: false,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Error / disabled',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                ),
                maxLength: 200,
                validator:
                    VoicesTextFieldValidationResult.error('Error message'),
                enabled: false,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'success / warning / error',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                ),
                validator: (value) {
                  if (value == 'success') {
                    return const VoicesTextFieldValidationResult(
                      status: VoicesTextFieldStatus.success,
                    );
                  } else if (value == 'warning') {
                    return const VoicesTextFieldValidationResult(
                      status: VoicesTextFieldStatus.warning,
                      errorMessage: 'Warning message',
                    );
                  } else if (value == 'error') {
                    return const VoicesTextFieldValidationResult(
                      status: VoicesTextFieldStatus.error,
                      errorMessage: 'Error message',
                    );
                  } else {
                    return const VoicesTextFieldValidationResult(
                      status: VoicesTextFieldStatus.none,
                    );
                  }
                },
                maxLength: 200,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Field label',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                ),
                maxLength: 200,
                minLines: 6,
                maxLines: 10,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Resizable',
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
