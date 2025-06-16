import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/dev_tools/document_data_preview/widget/documents_data_list_view.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/x_close_button.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentDataPreviewPage extends StatefulWidget {
  final DocumentRef ref;

  const DocumentDataPreviewPage._({
    required this.ref,
  });

  @override
  State<DocumentDataPreviewPage> createState() => _DocumentDataPreviewPageState();

  static Future<void> show(
    BuildContext context, {
    required DocumentRef ref,
  }) {
    final route = PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: DocumentDataPreviewPage._(ref: ref),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      settings: const RouteSettings(name: '/document-data-preview'),
    );

    return Navigator.push(context, route);
  }
}

class _DocumentDataPreviewPageState extends State<DocumentDataPreviewPage> {
  late final DocumentDataPreviewBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: const VoicesAppBar(leading: XCloseButton()),
        body: Column(
          children: [
            _Title(ref: widget.ref),
            const SizedBox(height: 16),
            const Expanded(child: DocumentsDataListView()),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(DocumentDataPreviewPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ref != oldWidget.ref) {
      _bloc.add(LookupRefDocumentsEvent(ref: widget.ref));
    }
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bloc = Dependencies.instance.get();
    _bloc.add(LookupRefDocumentsEvent(ref: widget.ref));
  }
}

class _Title extends StatelessWidget {
  final DocumentRef ref;

  const _Title({
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      ref.toString(),
      style: context.textTheme.titleMedium,
    );
  }
}
