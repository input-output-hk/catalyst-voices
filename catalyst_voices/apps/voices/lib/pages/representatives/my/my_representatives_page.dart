import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/representatives/my/widgets/header.dart';
import 'package:flutter/material.dart';

class MyRepresentativesPage extends StatefulWidget {
  const MyRepresentativesPage({super.key});

  @override
  State<MyRepresentativesPage> createState() => _MyRepresentativesPageState();
}

class _MyRepresentativesPageState extends State<MyRepresentativesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(),
        Expanded(
          child: Center(
            child: Text(
              'Coming soon...',
              style: context.textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }
}
