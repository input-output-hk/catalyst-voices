import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProposalApprovalPage extends StatelessWidget {
  const ProposalApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Header(),
        SizedBox(height: 30),
        _Content(),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          'No actions',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: context.pop,
        ),
        Expanded(
          child: Text(
            'Final Proposal Approval',
            style: context.textTheme.titleLarge,
          ),
        ),
        CloseButton(
          onPressed: Scaffold.of(context).closeEndDrawer,
        ),
      ],
    );
  }
}
