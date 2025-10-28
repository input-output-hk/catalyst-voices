import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database_language.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao_paging_strategy.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao_paging_strategy_dsl.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao_paging_strategy_raw.dart';
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
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage(
    PageRequest request, {
    CatalystDatabaseLanguage lang = CatalystDatabaseLanguage.raw,
  }) async {
    final effectivePage = request.page.clamp(0, double.infinity).toInt();
    final effectiveSize = request.size.clamp(0, 999);

    if (effectiveSize == 0) {
      return Page(items: const [], total: 0, page: effectivePage, maxPerPage: effectiveSize);
    }

    // ignore: omit_local_variable_types
    final ProposalsV2DaoPagingStrategy strategy = switch (lang) {
      CatalystDatabaseLanguage.dsl => ProposalsV2DaoPagingStrategyDsl(attachedDatabase),
      CatalystDatabaseLanguage.raw => ProposalsV2DaoPagingStrategyRaw(attachedDatabase),
    };

    final items = await strategy.queryVisibleProposalsPage(effectivePage, effectiveSize);
    final total = await strategy.countVisibleProposals();

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
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage(
    PageRequest request, {
    CatalystDatabaseLanguage lang,
  });
}
