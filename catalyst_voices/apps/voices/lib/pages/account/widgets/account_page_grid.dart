import 'package:catalyst_voices/widgets/common/columns_row.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class AccountPageGrid extends StatelessWidget {
  final List<Widget> children;

  const AccountPageGrid({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<int>(
      xs: 1,
      sm: 1,
      other: 2,
      builder: (context, data) {
        return ColumnsRow(
          columnsCount: data,
          mainAxisSpacing: 28,
          crossAxisSpacing: 20,
          crossAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
