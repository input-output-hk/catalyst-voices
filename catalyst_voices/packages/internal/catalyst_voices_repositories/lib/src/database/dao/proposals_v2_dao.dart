import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:drift/drift.dart';

@DriftAccessor(
  tables: [
    DocumentsV2,
    LocalDocumentsDrafts,
    DocumentsLocalMetadata,
  ],
)
class DriftProposalsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftProposalsV2DaoMixin
    implements ProposalsV2Dao {
  DriftProposalsV2Dao(super.attachedDatabase);

  @override
  Future<DocumentEntityV2?> getProposal(DocumentRef ref) async {
    final query = select(documentsV2)
      ..where((tbl) => tbl.id.equals(ref.id) & tbl.type.equals(DocumentType.proposalDocument.uuid));

    if (ref.isExact) {
      query.where((tbl) => tbl.ver.equals(ref.version!));
    } else {
      query
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
        ..limit(1);
    }

    return query.getSingleOrNull();
  }

  @override
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage(PageRequest request) async {
    final effectivePage = request.page;
    final effectiveSize = request.size;

    assert(effectiveSize < 1000, 'Max query size is 999');

    if (effectiveSize == 0) {
      return Page(items: const [], total: 0, page: effectivePage, maxPerPage: effectiveSize);
    }

    final proposals = alias(documentsV2, 'proposals');
    final latestVer = alias(documentsV2, 'latestVer');

    final maxVer = latestVer.ver.max();
    final latestVerQuery = selectOnly(latestVer)
      ..where(latestVer.type.equals(DocumentType.proposalDocument.uuid))
      ..addColumns([latestVer.id, maxVer])
      ..groupBy([latestVer.id]);
    final latestVerSubquery = Subquery(latestVerQuery, 'latestVer');

    final proposalsQuery =
        select(proposals).join([
            innerJoin(
              latestVerSubquery,
              Expression.and([
                latestVerSubquery.ref(latestVer.id).equalsExp(proposals.id),
                latestVerSubquery.ref(maxVer).equalsExp(proposals.ver),
              ]),
              useColumns: false,
            ),
          ])
          ..where(proposals.type.equalsValue(DocumentType.proposalDocument))
          ..orderBy([OrderingTerm.desc(proposals.ver)])
          ..limit(effectiveSize, offset: effectivePage * effectiveSize);

    final items = await proposalsQuery.map((row) {
      final proposal = row.readTable(proposals);

      return JoinedProposalBriefEntity(proposal: proposal);
    }).get();

    // Separate total count
    final totalQuery = (selectOnly(documentsV2)
      ..addColumns([documentsV2.id.count(distinct: true)])
      ..where(documentsV2.type.equals(DocumentType.proposalDocument.uuid)));

    final total = await totalQuery
        .map((row) => row.read(documentsV2.id.count(distinct: true)) ?? 0)
        .getSingle();

    return Page(
      items: items,
      total: total,
      page: effectivePage,
      maxPerPage: effectiveSize,
    );
  }
}

abstract interface class ProposalsV2Dao {
  /// Retrieves a proposal by its reference.
  ///
  /// Filters by type == proposalDocument.
  /// If [ref] is exact (has version), returns the specific version.
  /// If loose (no version), returns the latest version by createdAt.
  /// Returns null if no matching proposal is found.
  Future<DocumentEntityV2?> getProposal(DocumentRef ref);

  /// Retrieves a paginated page of brief proposals (lightweight for lists/UI).
  ///
  /// Filters by type == proposalDocument.
  /// Returns latest version per id, ordered by descending ver (UUIDv7 lexical).
  /// Handles pagination via request.page (0-based) and request.size.
  /// Each item is a [JoinedProposalBriefEntity] (extensible for joins).
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage(PageRequest request);
}
