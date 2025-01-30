import 'package:catalyst_voices/common/ext/preferences_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionTimezoneMenuTile extends StatelessWidget {
  const SessionTimezoneMenuTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, TimezonePreferences>(
      selector: (state) => state.settings.timezone,
      builder: (context, state) => _SegmentsTile(selected: state),
    );
  }
}

class _SegmentsTile extends StatelessWidget {
  final TimezonePreferences selected;

  const _SegmentsTile({
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return MenuSegmentsItemTile<TimezonePreferences>(
      title: Text(context.l10n.timezone),
      segments: (
        first: TimezonePreferences.utc.asSegmentButton(context),
        second: TimezonePreferences.local.asSegmentButton(context),
      ),
      selected: selected,
      onChanged: (value) {
        context.read<SessionCubit>().updateTimezone(value);
      },
    );
  }
}

extension _ButtonSegmentBuilder on TimezonePreferences {
  ButtonSegment<TimezonePreferences> asSegmentButton(BuildContext context) {
    return ButtonSegment(
      value: this,
      icon: icon().buildIcon(),
      label: Text(localizedName(context)),
    );
  }
}
