import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:mocktail/mocktail.dart';

class FakeFeatureFlagsRepository extends Fake implements FeatureFlagsRepository {
  @override
  bool isEnabled(FeatureFlag featureFlag) => true;
}
