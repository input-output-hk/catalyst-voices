import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group(SystemStatusCubit, () {
    late SystemStatusRepository repository;
    late SystemStatusCubit cubit;

    setUp(() {
      repository = _MockSystemStatusRepository();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state is empty', () {
      when(() => repository.pollComponentStatuses()).thenAnswer((_) => const Stream.empty());

      cubit = SystemStatusCubit(repository);

      expect(cubit.state, equals(const SystemStatusState()));
    });

    test('emits SystemStatusIssueSignal when at least one component is not operational', () async {
      final statuses = [
        const ComponentStatus(name: 'api', isOperational: false),
        const ComponentStatus(name: 'database', isOperational: true),
      ];

      when(() => repository.pollComponentStatuses()).thenAnswer((_) => Stream.value(statuses));

      cubit = SystemStatusCubit(repository);

      await expectLater(
        cubit.signalStream,
        emits(isA<SystemStatusIssueSignal>()),
      );
    });

    test('emits CancelSystemStatusIssueSignal when all components are operational', () async {
      final statuses = [
        const ComponentStatus(name: 'api', isOperational: true),
        const ComponentStatus(name: 'database', isOperational: true),
      ];

      when(() => repository.pollComponentStatuses()).thenAnswer((_) => Stream.value(statuses));

      cubit = SystemStatusCubit(repository);

      await expectLater(
        cubit.signalStream,
        emits(isA<CancelSystemStatusIssueSignal>()),
      );
    });

    test('does not emit duplicate signals for identical statuses', () async {
      final statuses = [const ComponentStatus(name: 'api', isOperational: true)];

      when(
        () => repository.pollComponentStatuses(),
      ).thenAnswer((_) => Stream.fromIterable([statuses, statuses]));

      cubit = SystemStatusCubit(repository);

      await expectLater(
        cubit.signalStream,
        emits(isA<CancelSystemStatusIssueSignal>()),
      );
    });
  });
}

class _MockSystemStatusRepository extends Mock implements SystemStatusRepository {}
