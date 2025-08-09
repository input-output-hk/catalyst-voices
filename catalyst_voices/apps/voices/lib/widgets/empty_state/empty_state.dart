import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final Widget? title;
  final Widget? description;
  final Widget? image;

  final EdgeInsetsGeometry padding;
  final BoxConstraints constraints;

  const EmptyState({
    super.key,
    this.title,
    this.description,
    this.image,
    this.padding = const EdgeInsets.symmetric(vertical: 64),
    this.constraints = const BoxConstraints.tightFor(width: 430),
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final description = this.description;
    final image = this.image;

    return Container(
      padding: padding,
      constraints: constraints,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null) ...[
            image,
            const SizedBox(height: 24),
          ],
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              if (title != null) _Title(child: title),
              if (description != null) _Description(child: description),
            ],
          ),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final Widget child;

  const _Description({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final style = (context.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel1,
    );

    return DefaultTextStyle(
      style: style,
      textAlign: TextAlign.center,
      child: child,
    );
  }
}

class _Title extends StatelessWidget {
  final Widget child;

  const _Title({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final style = (context.textTheme.titleMedium ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel1,
    );

    return DefaultTextStyle(
      style: style,
      textAlign: TextAlign.center,
      child: child,
    );
  }
}
