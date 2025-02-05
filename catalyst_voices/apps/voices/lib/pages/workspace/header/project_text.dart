part of 'workspace_header.dart';

class ProjectText extends StatelessWidget {
  const ProjectText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.l10n.catalyst,
      style: theme.textTheme.titleSmall?.copyWith(
        color: VoicesColors.lightTextOnPrimaryLevel1,
      ),
    );
  }
}
