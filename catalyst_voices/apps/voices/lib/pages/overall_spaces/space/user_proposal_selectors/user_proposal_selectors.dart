import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/widgets/cards/small_proposal_card.dart';
import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// As widget across two overviews are almost similar and are not reusable
// anywhere else it usefull to use as part
part 'discovery_overview_proposal_selector.dart';
part 'user_proposals_selector_widgets.dart';
part 'workspace_overview_proposal_selector.dart';
