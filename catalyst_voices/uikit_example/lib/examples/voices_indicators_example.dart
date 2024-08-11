import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesIndicatorsExample extends StatelessWidget {
  static const String route = '/indicators-example';

  const VoicesIndicatorsExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Indicators')),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 42, vertical: 24),
        child: Column(
          children: [
            Text('Process Stepper Indicator'),
            SizedBox(height: 8),
            _Steps(),
            SizedBox(height: 22),
            Text('Linear - Indeterminate'),
            SizedBox(height: 8),
            VoicesLinearProgressIndicator(),
            SizedBox(height: 16),
            VoicesLinearProgressIndicator(showTrack: false),
            SizedBox(height: 22),
            Text('Linear - Fixed'),
            SizedBox(height: 8),
            VoicesLinearProgressIndicator(value: 0.25),
            SizedBox(height: 16),
            VoicesLinearProgressIndicator(value: 0.25, showTrack: false),
            SizedBox(height: 22),
            Text('Circular - Indeterminate'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VoicesCircularProgressIndicator(),
                SizedBox(width: 16),
                VoicesCircularProgressIndicator(showTrack: false),
              ],
            ),
            SizedBox(height: 22),
            Text('Circular - Fixed'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VoicesCircularProgressIndicator(value: 0.75),
                SizedBox(width: 16),
                VoicesCircularProgressIndicator(value: 0.75, showTrack: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _OnboardingStep {
  one,
  two,
  three,
  four,
  five;

  ProcessProgressStep asStep() {
    return ProcessProgressStep(
      value: this,
      name: stepName,
    );
  }

  String get stepName {
    return switch (this) {
      _OnboardingStep.one => 'Step 1',
      _OnboardingStep.two => 'Step 2',
      _OnboardingStep.three => 'Step 3',
      _OnboardingStep.four => 'Step 4',
      _OnboardingStep.five => 'Step 5',
    };
  }
}

class _Steps extends StatefulWidget {
  const _Steps();

  @override
  State<_Steps> createState() => _StepsState();
}

class _StepsState extends State<_Steps> {
  final completedSteps = <_OnboardingStep>{};
  _OnboardingStep? currentStep = _OnboardingStep.one;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProcessProgressIndicator(
          steps: _OnboardingStep.values.map((e) => e.asStep()).toList(),
          completed: completedSteps,
          current: currentStep,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VoicesFilledButton(
              onTap: completedSteps.isEmpty
                  ? null
                  : () => setState(_goToPreviousStep),
              child: const Text('Previous'),
            ),
            const SizedBox(width: 16),
            VoicesFilledButton(
              onTap: completedSteps.containsAll(_OnboardingStep.values)
                  ? null
                  : () => setState(_goToNextStep),
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  void _goToNextStep() {
    final currentStep = this.currentStep;
    if (currentStep != null) {
      completedSteps.add(currentStep);

      final index = _OnboardingStep.values.indexOf(currentStep);
      if (index < _OnboardingStep.values.length - 1) {
        this.currentStep = _OnboardingStep.values[index + 1];
      }
    } else {
      this.currentStep = _OnboardingStep.values.first;
    }
  }

  void _goToPreviousStep() {
    final currentStep = this.currentStep;
    if (currentStep != null) {
      completedSteps.remove(currentStep);

      final index = _OnboardingStep.values.indexOf(currentStep);
      if (index > 0) {
        final newStep = _OnboardingStep.values[index - 1];

        completedSteps.remove(newStep);
        this.currentStep = newStep;
      }
    }
  }
}
