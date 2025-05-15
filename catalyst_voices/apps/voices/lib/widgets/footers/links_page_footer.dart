import 'package:catalyst_voices/widgets/footers/page_footer.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class LinksPageFooter extends StatelessWidget {
  final List<Widget> upperChildren;
  final List<Widget> lowerChildren;

  const LinksPageFooter({
    super.key,
    required this.upperChildren,
    required this.lowerChildren,
  }) : assert(
          upperChildren.length > 0 || lowerChildren.length > 0,
          'Make sure links page footer is not empty!',
        );

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyLarge ?? const TextStyle(),
      child: IconButtonTheme(
        data: const IconButtonThemeData(
          style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size.square(48)),
          ),
        ),
        child: PageFooter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 8,
                children:
                    upperChildren.separatedBy(const _ResponsiveGap()).toList(),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 8,
                children:
                    lowerChildren.separatedBy(const _ResponsiveGap()).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResponsiveGap extends StatelessWidget {
  const _ResponsiveGap();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<double>(
      builder: (context, data) => SizedBox(width: data),
      lg: 32,
      other: 16,
    );
  }
}
