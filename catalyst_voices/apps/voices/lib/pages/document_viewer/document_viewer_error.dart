import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/pages/error_page/error_page.dart';
import 'package:catalyst_voices/routes/routing/root_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DocumentViewerError extends StatelessWidget {
  const DocumentViewerError({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DocumentViewerCubit, DocumentViewerState, ErrorVisibilityState>(
      selector: (state) => (show: state.showError, data: state.error),
      builder: (context, state) {
        return Offstage(
          offstage: !state.show,
          child: _DocumentViewerError(exception: state.data),
        );
      },
    );
  }
}

class _NotFoundError extends StatelessWidget {
  final String? message;

  const _NotFoundError({this.message});

  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      image: VoicesAssets.images.notFound404,
      title: context.l10n.proposalViewNotFoundTitle,
      message: message ?? context.l10n.proposalViewNotFoundMessage,
      button: VoicesTextButton(
        leading: VoicesAssets.icons.arrowNarrowRight.buildIcon(),
        child: Text(context.l10n.proposalViewNotFoundButton),
        onTap: () => const RootRoute().go(context),
      ),
    );
  }
}

class _DocumentViewerError extends StatelessWidget {
  final LocalizedException? exception;

  const _DocumentViewerError({required this.exception});

  @override
  Widget build(BuildContext context) {
    return switch (exception) {
      LocalizedNotFoundException() => const _NotFoundError(),
      LocalizedDocumentReferenceException() => _NotFoundError(message: exception?.message(context)),
      LocalizedDocumentHiddenException() => _NotFoundError(message: exception?.message(context)),
      _ => _RecoverableError(title: exception?.message(context)),
    };
  }
}

class _RecoverableError extends StatelessWidget {
  final String? title;

  const _RecoverableError({this.title});

  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      image: VoicesAssets.images.magGlass,
      maxImageWidth: 300,
      title: title ?? context.l10n.somethingWentWrong,
      message: context.l10n.proposalViewLoadErrorMessage,
      button: VoicesTextButton(
        leading: VoicesAssets.icons.refresh.buildIcon(),
        child: Text(context.l10n.refresh),
        onTap: () => context.read<DocumentViewerCubit>().retryLastRef(),
      ),
    );
  }
}
