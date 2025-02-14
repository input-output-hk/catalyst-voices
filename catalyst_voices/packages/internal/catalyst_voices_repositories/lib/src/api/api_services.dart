import 'package:catalyst_voices_repositories/generated/api/client_index.dart';
import 'package:catalyst_voices_repositories/src/api/review_module.dart';

final class ApiServices {
  final CatGateway cat;
  final Vit vit;
  final ReviewModule review;

  factory ApiServices({
    required Uri uri,
  }) {
    final cat = CatGateway.create();
    final vit = Vit.create();
    final review = ReviewModule.create();

    return ApiServices._(
      cat: cat,
      vit: vit,
      review: review,
    );
  }

  const ApiServices._({
    required this.cat,
    required this.vit,
    required this.review,
  });
}
