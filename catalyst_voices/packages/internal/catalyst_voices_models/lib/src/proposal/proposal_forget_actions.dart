import 'package:equatable/equatable.dart';

final class ExportProposalForgetAction extends ProposalForgetActions {
  const ExportProposalForgetAction();

  @override
  List<Object?> get props => [];
}

final class ForgetProposalForgetAction extends ProposalForgetActions {
  const ForgetProposalForgetAction();

  @override
  List<Object?> get props => [];
}

sealed class ProposalForgetActions extends Equatable {
  const ProposalForgetActions();
}
