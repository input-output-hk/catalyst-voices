import 'package:catalyst_voices/widgets/layouts/header_and_content_layout.dart';
import 'package:flutter/material.dart';

part 'widgets/voting_content.dart';
part 'widgets/voting_header.dart';

class VotingPage extends StatelessWidget {
  const VotingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HeaderAndContentLayout(
      header: _VotingHeader(),
      content: _VotingContent(),
    );
  }
}
