import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(AdminToolsCubit(), () {
    blocTest<AdminToolsCubit, AdminToolsState>(
      'initial state is disabled',
      build: AdminToolsCubit.new,
      verify: (cubit) => expect(cubit.state.enabled, isFalse),
    );

    blocTest<AdminToolsCubit, AdminToolsState>(
      'enable() enables admin tools',
      build: AdminToolsCubit.new,
      act: (cubit) => cubit.enable(),
      verify: (cubit) => expect(cubit.state.enabled, isTrue),
    );

    blocTest<AdminToolsCubit, AdminToolsState>(
      'enable() and disable() keeps admin tools disabled',
      build: AdminToolsCubit.new,
      act: (cubit) {
        cubit
          ..enable()
          ..disable();
      },
      verify: (cubit) => expect(cubit.state.enabled, isFalse),
    );

    blocTest<AdminToolsCubit, AdminToolsState>(
      'updateCampaignStage() update campaign stage',
      build: AdminToolsCubit.new,
      act: (cubit) {
        cubit.updateCampaignStage(CampaignStage.completed);
      },
      verify: (cubit) {
        expect(cubit.state.campaignStage, equals(CampaignStage.completed));
      },
    );

    blocTest<AdminToolsCubit, AdminToolsState>(
      'updateSessionStatus() update session status',
      build: AdminToolsCubit.new,
      act: (cubit) {
        cubit.updateSessionStatus(SessionStatus.visitor);
      },
      verify: (cubit) {
        expect(cubit.state.sessionStatus, equals(SessionStatus.visitor));
      },
    );
  });
}
