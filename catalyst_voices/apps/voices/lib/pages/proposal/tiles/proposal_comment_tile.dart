import 'package:flutter/material.dart';

class ProposalCommentTile extends StatelessWidget {
  final String message;

  const ProposalCommentTile({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Placeholder(child: Text(message));
  }
}
