import 'package:catalyst_voices/pages/dev_tools/widgets/document_ref_field.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/document_search_button.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentLookup extends StatefulWidget {
  const DocumentLookup({super.key});

  @override
  State<DocumentLookup> createState() => _DocumentLookupState();
}

class _DocumentLookupState extends State<DocumentLookup> {
  final _controller = DocumentRefController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DocumentRefField(
          controller: _controller,
          onSubmitted: (value) => _openDocDetails(ref: value),
        ),
        const SizedBox(height: 4),
        DocumentSearchButton(
          onTap: _openDocDetails,
          refController: _controller,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _openDocDetails({DocumentRef? ref}) {
    ref ??= _controller.value;
    assert(ref != null, 'ref is invalid!');

    print(ref);
  }
}
