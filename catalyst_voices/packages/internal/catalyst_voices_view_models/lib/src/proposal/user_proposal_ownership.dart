import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class AuthorProposalOwnership extends UserProposalOwnership {
  const AuthorProposalOwnership();

  @override
  SvgGenImage get icon => VoicesAssets.icons.user;

  @override
  String title(BuildContext context) {
    return context.l10n.mainProposer;
  }
}

final class CollaboratorProposalOwnership extends UserProposalOwnership {
  const CollaboratorProposalOwnership();

  @override
  SvgGenImage get icon => VoicesAssets.icons.userGroup;

  @override
  String title(BuildContext context) {
    return context.l10n.collaborator;
  }
}

sealed class UserProposalOwnership extends Equatable {
  const UserProposalOwnership();

  factory UserProposalOwnership.fromActiveAccount({
    CatalystId? authorId,
    CatalystId? activeAccountId,
  }) {
    if (activeAccountId != null && authorId != null && authorId.isSameAs(activeAccountId)) {
      return const AuthorProposalOwnership();
    }
    // If user can see the proposal but isn't the author, they're a collaborator
    return const CollaboratorProposalOwnership();
  }

  SvgGenImage get icon;

  @override
  List<Object?> get props => [];

  String title(BuildContext context);
}
