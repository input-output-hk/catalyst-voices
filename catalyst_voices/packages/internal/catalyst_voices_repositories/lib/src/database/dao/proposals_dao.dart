import 'dart:convert' show utf8;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

@DriftAccessor(
  tables: [
    Documents,
    DocumentsMetadata,
  ],
)
class DriftProposalsDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftProposalsDaoMixin
    implements ProposalsDao {
  DriftProposalsDao(super.attachedDatabase);

  @override
  Future<Page<JoinedProposalEntity>> queryProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  }) async {
    return Page(
      page: 0,
      maxPerPage: 0,
      total: 0,
      items: [],
    );
  }

  @override
  Stream<ProposalsCount> watchCount({
    required ProposalsCountFilters filters,
  }) async* {
    final proposalsCount = (documents.idHi + documents.idLo).count(
      distinct: true,
      filter: documents.type.equalsValue(DocumentType.proposalDocument),
    );

    final select = selectOnly(documents)
      ..addColumns([
        proposalsCount,
      ]);

    final stream = select
        .map((row) => row.read(proposalsCount))
        .watchSingleOrNull()
        .map((event) => event ?? 0);

    await for (final total in stream) {
      final finals = await _getFinalProposalsCount();
      final drafts = total - finals;

      yield ProposalsCount(
        total: total,
        drafts: drafts,
        finals: finals,
      );
    }
  }

  Future<int> _getFinalProposalsCount() {
    final refId = documents.metadata.jsonExtract<Uint8List>(r'$.ref.id');
    final select = selectOnly(documents, distinct: true)
      ..addColumns([
        refId,
        documents.content,
      ])
      ..where(documents.type.equalsValue(DocumentType.proposalActionDocument))
      ..orderBy([OrderingTerm.desc(documents.verHi)]);

    return select
        .map((row) {
          final proposalId = utf8.decode(row.read(refId)!);
          final content = row.readWithConverter(documents.content);
          final finalKey = ProposalSubmissionActionDto.aFinal.key;
          final isFinal = content?.data['action'] == finalKey;

          print(
            'proposalId[$proposalId], '
            'isFinal[$isFinal] -> '
            'content[$content]',
          );

          return isFinal ? 1 : 0;
        })
        .get()
        .then((value) => value.fold<int>(0, (total, count) => total + count));
  }
}

abstract interface class ProposalsDao {
  Future<Page<JoinedProposalEntity>> queryProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  });

  Stream<ProposalsCount> watchCount({
    required ProposalsCountFilters filters,
  });
}
