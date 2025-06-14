import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/document_ref_field.dart';
import 'package:flutter/material.dart';

class DocumentLookup extends StatelessWidget {
  const DocumentLookup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Title(),
        SizedBox(height: 4),
        DocumentRefField(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Lookup',
      style: context.textTheme.bodyMedium,
    );
  }
}
