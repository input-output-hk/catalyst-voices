import 'package:catalyst_voices_blocs/src/proposal/proposal.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ProposalBloc extends Bloc<ProposalEvent, ProposalState> {
  final ProposalService _proposalService;

  ProposalBloc(
    this._proposalService,
  ) : super(const ProposalState());
}
