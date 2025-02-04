part of 'workspace_header.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      Space.workspace.localizedName(context.l10n),
      style: theme.textTheme.headlineLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}
