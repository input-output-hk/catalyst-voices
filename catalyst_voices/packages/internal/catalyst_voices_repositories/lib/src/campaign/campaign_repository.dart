import 'dart:convert';
import 'dart:io';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

class CampaignRepository {
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    final now = DateTime.now();

    const path = Paths.f14ProposalSchema;
    final encodedSchema = File(path).readAsStringSync();
    final decodedSchema = json.decode(encodedSchema) as Map<String, dynamic>;

    final proposalTemplateDto = DocumentSchemaDto.fromJson(decodedSchema);
    final documentSchema = proposalTemplateDto.toModel();

    return Campaign(
      id: id,
      name: 'Boost Social Entrepreneurship',
      description: 'We are currently only decentralizing our technology, '
          'failing to rethink how interactions play out in novel '
          'web3/p2p Action networks.',
      startDate: now.add(const Duration(days: 10)),
      endDate: now.add(const Duration(days: 92)),
      proposalsCount: 0,
      publish: CampaignPublish.draft,
      proposalTemplate: documentSchema,
    );
  }
}
