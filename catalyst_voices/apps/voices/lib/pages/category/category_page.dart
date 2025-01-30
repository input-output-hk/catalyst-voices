import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String categoryId;

  const CategoryPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Body(categoryId: categoryId),
        const _CardInformation(),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String categoryId;

  const _Body({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Placeholder(),
    );
  }
}

class _CardInformation extends StatelessWidget {
  const _CardInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
