import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/co_proposers_consent_page_content.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class CoProposersConsentPage extends StatefulWidget {
  const CoProposersConsentPage({super.key});

  @override
  State<CoProposersConsentPage> createState() => _CoProposersConsentPageState();
}

class _CoProposersConsentPageState extends State<CoProposersConsentPage> {
  late final DisplayConsentCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CoProposersConsentPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _cubit = Dependencies.instance.get<DisplayConsentCubit>();
    unawaited(_cubit.init());
  }
}
