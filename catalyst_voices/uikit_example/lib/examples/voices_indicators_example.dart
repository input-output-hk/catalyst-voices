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
            _Steps(),
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
      _ => 'Catalyst Onboarding questions',
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
  _OnboardingStep? currentStep;

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
        VoicesFilledButton(
          onTap: completedSteps.containsAll(_OnboardingStep.values)
              ? null
              : () {
                  setState(() {
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
                  });
                },
          child: const Text('Next'),
        ),
      ],
    );
  }
}
