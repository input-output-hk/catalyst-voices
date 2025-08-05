import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

/// Resolves links to resources base on current app environment type.
final class ResourceUrlResolver
    implements ShareAppResourceUrlResolver, ShareReviewsResourceUrlResolver {
  final AppEnvironment environment;

  const ResourceUrlResolver({
    required this.environment,
  });

  @override
  Uri becomeReviewer() {
    return environment.type.reviews.replace(path: 'register');
  }

  @override
  Uri proposal({required DocumentRef ref}) {
    final app = environment.type.app;
    final location = ProposalRoute.fromRef(ref: ref).location;

    return app.resolve(location);
  }
}
