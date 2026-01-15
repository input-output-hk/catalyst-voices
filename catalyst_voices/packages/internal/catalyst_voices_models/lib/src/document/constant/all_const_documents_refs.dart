import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final List<CategoryTemplatesRefs> allConstantDocumentRefs = [
  ...f14ConstDocumentsRefs,
  ...f15ConstDocumentsRefs,
];

List<CategoryTemplatesRefs> constantDocumentRefsPerCampaign(DocumentRef campaignRef) {
  return switch (campaignRef) {
    Campaign.f14Ref => f14ConstDocumentsRefs,
    Campaign.f15Ref => f15ConstDocumentsRefs,
    _ => [],
  };
}
