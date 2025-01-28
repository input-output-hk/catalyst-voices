import 'package:catalyst_voices/common/ext/preferences_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionThemeMenuTile extends StatelessWidget {
  const SessionThemeMenuTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, ThemePreferences>(
      selector: (state) => state.settings.theme,
      builder: (context, state) => _SegmentsTile(selected: state),
    );
  }
}

class _SegmentsTile extends StatelessWidget {
  final ThemePreferences selected;

  const _SegmentsTile({
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return MenuSegmentsItemTile<ThemePreferences>(
      title: Text('Theme'),
      segments: (
        first: ThemePreferences.dark.asSegmentButton(context),
        second: ThemePreferences.light.asSegmentButton(context),
      ),
      selected: selected,
      onChanged: (value) {
        //
      },
    );
  }
}

extension _ButtonSegmentBuilder on ThemePreferences {
  ButtonSegment<ThemePreferences> asSegmentButton(BuildContext context) {
    return ButtonSegment(
      value: this,
      icon: icon().buildIcon(),
      label: Text(localizedName(context)),
    );
  }
}
