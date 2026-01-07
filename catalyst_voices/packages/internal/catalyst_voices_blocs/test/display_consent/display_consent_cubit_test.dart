import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const PageRequest(page: 0, size: 999));
    registerFallbackValue(
      CollaboratorInvitationsProposalsFilter(
        CatalystIdFactory.create(),
      ),
    );
    registerFallbackValue(DocumentRefFactory.signedDocumentRef());
    registerFallbackValue(CollaboratorProposalAction.acceptInvitation);
  });

  group(DisplayConsentCubit, () {
    late _MockUserService userService;
    late _MockProposalService proposalService;
    late DisplayConsentCubit cubit;
    late StreamController<Account?> accountController;
    late StreamController<Page<ProposalBriefData>> proposalController;

    setUp(() {
      userService = _MockUserService();
      proposalService = _MockProposalService();
      accountController = StreamController<Account?>.broadcast();
      proposalController = StreamController<Page<ProposalBriefData>>.broadcast();

      when(
        () => userService.watchUnlockedActiveAccount,
      ).thenAnswer((_) => accountController.stream);

      cubit = DisplayConsentCubit(userService, proposalService);
    });

    tearDown(() async {
      await cubit.close();
      await accountController.close();
      await proposalController.close();
    });

    group('initialization', () {
      test('initial state is empty', () {
        expect(cubit.state, const DisplayConsentState());
        expect(cubit.state.items, isEmpty);
      });
    });

    group('init', () {
      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'subscribes to user account changes',
        build: () {
          when(
            () => proposalService.watchProposalsBriefPageV2(
              request: any(named: 'request'),
              filters: any(named: 'filters'),
            ),
          ).thenAnswer((_) => proposalController.stream);
          return cubit;
        },
        act: (cubit) async {
          cubit.init();
        },
        verify: (_) {
          verify(() => userService.watchUnlockedActiveAccount).called(1);
        },
      );

      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'emits new state when account changes and proposals are received',
        build: () {
          when(
            () => proposalService.watchProposalsBriefPageV2(
              request: any(named: 'request'),
              filters: any(named: 'filters'),
            ),
          ).thenAnswer((_) => proposalController.stream);

          return cubit;
        },
        act: (cubit) async {
          cubit.init();
          final catalystId = CatalystIdFactory.create();
          final mockKeychain = _MockKeychain();
          when(() => mockKeychain.id).thenReturn('test-keychain');

          final account = Account.dummy(
            catalystId: catalystId,
            keychain: mockKeychain,
          );

          accountController.add(account);
          await Future<void>.delayed(const Duration(milliseconds: 50));

          final proposal = ProposalBriefData(
            id: DocumentRefFactory.signedDocumentRef(),
            title: 'Test Proposal',
            categoryName: 'Category',
            author: CatalystIdFactory.create(),
            createdAt: DateTime(2024),
            collaborators: [
              ProposalDataCollaborator(
                id: catalystId,
                status: ProposalsCollaborationStatus.pending,
                createdAt: DateTime(2024, 1, 2),
              ),
            ],
          );

          proposalController.add(
            Page(
              items: [proposal],
              total: 1,
              page: 0,
              maxPerPage: 999,
            ),
          );
        },
        expect: () => [
          isA<DisplayConsentState>(),
          isA<DisplayConsentState>().having(
            (s) => s.items.length,
            'items length',
            1,
          ),
        ],
      );

      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'handles null account by using empty stream',
        build: () {
          when(
            () => proposalService.watchProposalsBriefPageV2(
              request: any(named: 'request'),
              filters: any(named: 'filters'),
            ),
          ).thenAnswer((_) => proposalController.stream);

          return cubit;
        },
        act: (cubit) async {
          cubit.init();
          accountController.add(null);
        },
        verify: (_) {
          verify(() => userService.watchUnlockedActiveAccount).called(1);
        },
      );
    });

    group('changeDisplayConsent', () {
      late CatalystId catalystId;
      late ProposalBriefData proposal;

      setUp(() {
        catalystId = CatalystIdFactory.create();
        proposal = ProposalBriefData(
          id: DocumentRefFactory.signedDocumentRef(),
          title: 'Test Proposal',
          categoryName: 'Category',
          author: CatalystIdFactory.create(),
          createdAt: DateTime(2024),
          collaborators: [
            ProposalDataCollaborator(
              id: catalystId,
              status: ProposalsCollaborationStatus.pending,
              createdAt: DateTime(2024, 1, 2),
            ),
          ],
        );

        when(
          () => proposalService.watchProposalsBriefPageV2(
            request: any(named: 'request'),
            filters: any(named: 'filters'),
          ),
        ).thenAnswer((_) => proposalController.stream);

        when(
          () => proposalService.submitCollaboratorProposalAction(
            ref: any(named: 'ref'),
            action: any(named: 'action'),
          ),
        ).thenAnswer((_) async {});
      });

      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'changes consent status to allowed and submits action',
        build: () => cubit,
        act: (cubit) async {
          // Initialize and populate the cubit
          cubit.init();
          final mockKeychain = _MockKeychain();
          when(() => mockKeychain.id).thenReturn('test-keychain');
          final account = Account.dummy(
            catalystId: catalystId,
            keychain: mockKeychain,
          );
          accountController.add(account);

          await Future<void>.delayed(const Duration(milliseconds: 50));

          proposalController.add(
            Page(
              items: [proposal],
              total: 1,
              page: 0,
              maxPerPage: 999,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 50));

          // Perform the action
          await cubit.changeDisplayConsent(
            id: proposal.id,
            displayConsentStatus: CollaboratorDisplayConsentStatus.allowed,
          );
        },
        skip: 1, // Skip the first emission from init
        expect: () => [
          isA<DisplayConsentState>().having(
            (s) => s.items.first.status,
            'status',
            CollaboratorDisplayConsentStatus.pending,
          ),
          isA<DisplayConsentState>().having(
            (s) => s.items.first.status,
            'status',
            CollaboratorDisplayConsentStatus.allowed,
          ),
        ],
        verify: (_) {
          verify(
            () => proposalService.submitCollaboratorProposalAction(
              ref: proposal.id,
              action: CollaboratorProposalAction.acceptInvitation,
            ),
          ).called(1);
        },
      );

      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'changes consent status to denied and submits action',
        build: () => cubit,
        act: (cubit) async {
          cubit.init();
          final mockKeychain = _MockKeychain();
          when(() => mockKeychain.id).thenReturn('test-keychain');
          final account = Account.dummy(
            catalystId: catalystId,
            keychain: mockKeychain,
          );
          accountController.add(account);

          await Future<void>.delayed(const Duration(milliseconds: 50));

          proposalController.add(
            Page(
              items: [proposal],
              total: 1,
              page: 0,
              maxPerPage: 999,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 50));

          await cubit.changeDisplayConsent(
            id: proposal.id,
            displayConsentStatus: CollaboratorDisplayConsentStatus.denied,
          );
        },
        skip: 1,
        expect: () => [
          isA<DisplayConsentState>().having(
            (s) => s.items.first.status,
            'status',
            CollaboratorDisplayConsentStatus.pending,
          ),
          isA<DisplayConsentState>().having(
            (s) => s.items.first.status,
            'status',
            CollaboratorDisplayConsentStatus.denied,
          ),
        ],
        verify: (_) {
          verify(
            () => proposalService.submitCollaboratorProposalAction(
              ref: proposal.id,
              action: CollaboratorProposalAction.rejectInvitation,
            ),
          ).called(1);
        },
      );

      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'updates lastDisplayConsentUpdate when changing status',
        build: () => cubit,
        act: (cubit) async {
          cubit.init();
          final mockKeychain = _MockKeychain();
          when(() => mockKeychain.id).thenReturn('test-keychain');
          final account = Account.dummy(
            catalystId: catalystId,
            keychain: mockKeychain,
          );
          accountController.add(account);
          await Future<void>.delayed(const Duration(milliseconds: 50));

          proposalController.add(
            Page(
              items: [proposal],
              total: 1,
              page: 0,
              maxPerPage: 999,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 50));

          await cubit.changeDisplayConsent(
            id: proposal.id,
            displayConsentStatus: CollaboratorDisplayConsentStatus.allowed,
          );
        },
        verify: (cubit) {
          expect(
            cubit.state.items.first.lastDisplayConsentUpdate,
            isNotNull,
          );
        },
      );

      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'reverts state and emits error when service call fails',
        build: () {
          when(
            () => proposalService.submitCollaboratorProposalAction(
              ref: any(named: 'ref'),
              action: any(named: 'action'),
            ),
          ).thenThrow(Exception('Network error'));
          return cubit;
        },
        act: (cubit) async {
          cubit.init();
          final mockKeychain = _MockKeychain();
          when(() => mockKeychain.id).thenReturn('test-keychain');
          final account = Account.dummy(
            catalystId: catalystId,
            keychain: mockKeychain,
          );
          accountController.add(account);
          await Future<void>.delayed(const Duration(milliseconds: 50));
          proposalController.add(
            Page(
              items: [proposal],
              total: 1,
              page: 0,
              maxPerPage: 999,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 50));

          await cubit.changeDisplayConsent(
            id: proposal.id,
            displayConsentStatus: CollaboratorDisplayConsentStatus.allowed,
          );
        },
        skip: 1,
        expect: () => [
          isA<DisplayConsentState>().having(
            (s) => s.items.first.status,
            'status reverted',
            CollaboratorDisplayConsentStatus.pending,
          ),
          isA<DisplayConsentState>().having(
            (s) => s.items.first.status,
            'status optimistically updated',
            CollaboratorDisplayConsentStatus.allowed,
          ),
          isA<DisplayConsentState>().having(
            (s) => s.items.first.status,
            'status reverted',
            CollaboratorDisplayConsentStatus.pending,
          ),
        ],
      );

      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'does nothing when proposal is not found',
        build: () => cubit,
        act: (cubit) async {
          cubit.init();
          final mockKeychain = _MockKeychain();
          when(() => mockKeychain.id).thenReturn('test-keychain');
          final account = Account.dummy(
            catalystId: catalystId,
            keychain: mockKeychain,
          );
          accountController.add(account);
          proposalController.add(
            Page(
              items: [proposal],
              total: 1,
              page: 0,
              maxPerPage: 999,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 50));

          // Try to change consent for a non-existent proposal
          await cubit.changeDisplayConsent(
            id: DocumentRefFactory.signedDocumentRef(),
            displayConsentStatus: CollaboratorDisplayConsentStatus.allowed,
          );
        },
        skip: 1,
        expect: () => <DisplayConsentState>[],
        verify: (_) {
          verifyNever(
            () => proposalService.submitCollaboratorProposalAction(
              ref: any(named: 'ref'),
              action: any(named: 'action'),
            ),
          );
        },
      );

      blocTest<DisplayConsentCubit, DisplayConsentState>(
        'handles multiple proposals correctly',
        build: () => cubit,
        act: (cubit) async {
          cubit.init();
          final mockKeychain = _MockKeychain();
          when(() => mockKeychain.id).thenReturn('test-keychain');
          final account = Account.dummy(
            catalystId: catalystId,
            keychain: mockKeychain,
          );

          final proposal2 = ProposalBriefData(
            id: DocumentRefFactory.signedDocumentRef(),
            title: 'Test Proposal 2',
            categoryName: 'Category',
            author: CatalystIdFactory.create(),
            createdAt: DateTime(2024, 1, 3),
            collaborators: [
              ProposalDataCollaborator(
                id: catalystId,
                status: ProposalsCollaborationStatus.pending,
                createdAt: DateTime(2024, 1, 4),
              ),
            ],
          );

          accountController.add(account);
          await Future<void>.delayed(const Duration(milliseconds: 50));
          proposalController.add(
            Page(
              items: [proposal, proposal2],
              total: 2,
              page: 0,
              maxPerPage: 999,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 50));

          await cubit.changeDisplayConsent(
            id: proposal.id,
            displayConsentStatus: CollaboratorDisplayConsentStatus.allowed,
          );
        },
        skip: 1,
        expect: () => [
          isA<DisplayConsentState>()
              .having(
                (s) => s.items.length,
                'items length',
                2,
              )
              .having(
                (s) => s.items.first.status,
                'first item status',
                CollaboratorDisplayConsentStatus.pending,
              )
              .having(
                (s) => s.items[1].status,
                'second item status',
                CollaboratorDisplayConsentStatus.pending,
              ),
          isA<DisplayConsentState>()
              .having(
                (s) => s.items.length,
                'items length',
                2,
              )
              .having(
                (s) => s.items.first.status,
                'first item status',
                CollaboratorDisplayConsentStatus.allowed,
              )
              .having(
                (s) => s.items[1].status,
                'second item status',
                CollaboratorDisplayConsentStatus.pending,
              ),
        ],
      );
    });

    group('close', () {
      test('cancels all subscriptions', () async {
        when(
          () => proposalService.watchProposalsBriefPageV2(
            request: any(named: 'request'),
            filters: any(named: 'filters'),
          ),
        ).thenAnswer((_) => proposalController.stream);

        cubit.init();
        await cubit.close();

        // Controllers won't have listeners after close
        expect(accountController.hasListener, isFalse);
        expect(proposalController.hasListener, isFalse);
      });
    });
  });
}

class _MockKeychain extends Mock implements Keychain {}

class _MockProposalService extends Mock implements ProposalService {}

class _MockUserService extends Mock implements UserService {}
