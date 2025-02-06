part of 'my_proposals.dart';

class SubTitleText extends StatelessWidget {
  const SubTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.l10n.myProposals,
      style: theme.textTheme.displaySmall?.copyWith(
        color: theme.colors.textOnPrimaryLevel0,
      ),
    );
  }
}
