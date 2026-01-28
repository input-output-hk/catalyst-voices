import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DocumentFavoriteButton extends StatelessWidget {
  const DocumentFavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DocumentViewerCubit, DocumentViewerState, bool>(
      selector: (state) => state.data.header.isFavorite,
      builder: (context, state) {
        return _DocumentFavoriteButton(isFavorite: state);
      },
    );
  }
}

class _DocumentFavoriteButton extends StatelessWidget {
  final bool isFavorite;

  const _DocumentFavoriteButton({
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return FavoriteButton(
      isFavorite: isFavorite,
      onChanged: (value) {
        unawaited(context.read<DocumentViewerCubit>().updateIsFavorite(value: value));
      },
    );
  }
}
