import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalFavoriteButton extends StatelessWidget {
  const ProposalFavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBloc, ProposalState, bool>(
      selector: (state) => state.data.header.isFavorite,
      builder: (context, state) {
        return _ProposalFavoriteButton(isFavorite: state);
      },
    );
  }
}

class _ProposalFavoriteButton extends StatelessWidget {
  final bool isFavorite;

  const _ProposalFavoriteButton({
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return FavoriteButton(
      isFavorite: isFavorite,
      onChanged: (value) {
        final event = UpdateProposalFavoriteEvent(isFavorite: value);

        context.read<ProposalBloc>().add(event);
      },
    );
  }
}
