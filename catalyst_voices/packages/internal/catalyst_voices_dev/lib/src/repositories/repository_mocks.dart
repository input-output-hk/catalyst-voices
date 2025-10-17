/// Mock implementations of repository interfaces for testing.
library;

import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:mocktail/mocktail.dart';

/// A mock implementation of [DocumentRepository] using mocktail.
///
/// Use this when you need to verify interactions or stub specific behaviors.
class MockDocumentRepository extends Mock implements DocumentRepository {}

/// A mock implementation of [ProposalRepository] using mocktail.
///
/// Use this when you need to verify interactions or stub specific behaviors.
class MockProposalRepository extends Mock implements ProposalRepository {}
