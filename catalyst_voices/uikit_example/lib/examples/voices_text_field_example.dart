import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
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
                decoration: const VoicesTextFieldDecoration(
                  labelText: 'Field label',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                  suffixIcon: Icon(CatalystVoicesIcons.chevron_down),
                ),
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
                  suffixIcon: Icon(CatalystVoicesIcons.chevron_down),
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
                  labelText: 'Field label',
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
                  labelText: 'Field label',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                  errorText: 'Error text',
                  suffixIcon: Icon(Icons.error_outline),
                ),
                maxLength: 200,
                enabled: false,
              ),
            ),
            SizedBox(
              width: 200,
              child: VoicesTextField(
                controller: _controller,
                decoration: VoicesTextFieldDecoration.singleBorder(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).colors.iconsSuccess!,
                    ),
                  ),
                  labelText: 'Field label',
                  helperText: 'Supporting text',
                  hintText: 'Hint text',
                  suffixIcon: Icon(
                    CatalystVoicesIcons.check_circle,
                    color: Theme.of(context).colors.iconsSuccess,
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}
