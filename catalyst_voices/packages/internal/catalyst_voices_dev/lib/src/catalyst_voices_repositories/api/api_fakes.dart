/// Mock implementations of API service interfaces for testing.
///
/// These mocks provide mocktail-based implementations that can be used
/// across all test suites without duplicating code.
library;

import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:mocktail/mocktail.dart';

/// A mock implementation of [CatGateway] for testing.
///
/// This mock uses mocktail's Mock base class to allow configuring
/// method stubs and verifying calls in tests.
class MockCatGateway extends Mock implements CatGateway {}

/// A mock implementation of [CatReviews] for testing.
///
/// This mock uses mocktail's Mock base class to allow configuring
/// method stubs and verifying calls in tests.
class MockCatReviews extends Mock implements CatReviews {}
