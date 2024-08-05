import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum _ButtonType {
  filled,
  outlined,
  text,
  textNeutral,
  textSecondary,
  icon,
  iconPrimary,
  iconFilled,
  iconTonal,
  iconOutlined;
}

enum _ButtonState { normal, disabled }

class VoicesButtonsExample extends StatelessWidget {
  static const String route = '/buttons-example';

  const VoicesButtonsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Buttons')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: _ButtonType.values
              .map(
                (type) {
                  return [
                    Text(
                      type.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    _ButtonRow(type: type),
                    _ButtonRow(type: type, addLeadingIcon: true),
                    _ButtonRow(type: type, addTrailingIcon: true),
                  ];
                },
              )
              .flattened
              .expandIndexed(
                (index, element) => [
                  if (index != 0) const SizedBox(height: 16),
                  element,
                ],
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow({
    required this.type,
    this.addLeadingIcon = false,
    this.addTrailingIcon = false,
  });

  final _ButtonType type;
  final bool addLeadingIcon;
  final bool addTrailingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _ButtonState.values
          .map((state) {
            return _buildButton(
              type,
              state,
              addLeadingIcon: addLeadingIcon,
              addTrailingIcon: addTrailingIcon,
            );
          })
          .expandIndexed(
            (index, element) => [
              if (index != 0) const SizedBox(width: 16),
              element,
            ],
          )
          .toList(),
    );
  }

  Widget _buildButton(
    _ButtonType type,
    _ButtonState state, {
    bool addLeadingIcon = false,
    bool addTrailingIcon = false,
  }) {
    return switch (type) {
      _ButtonType.filled => VoicesFilledButton(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: addLeadingIcon ? const Icon(Icons.add) : null,
          trailing: addTrailingIcon ? const Icon(Icons.add) : null,
          child: const Text('Label'),
        ),
      _ButtonType.outlined => VoicesOutlinedButton(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: addLeadingIcon ? const Icon(Icons.add) : null,
          trailing: addTrailingIcon ? const Icon(Icons.add) : null,
          child: const Text('Label'),
        ),
      _ButtonType.text => VoicesTextButton(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: addLeadingIcon ? const Icon(Icons.add) : null,
          trailing: addTrailingIcon ? const Icon(Icons.add) : null,
          child: const Text('Label'),
        ),
      _ButtonType.textNeutral => VoicesTextButton.neutral(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: addLeadingIcon ? const Icon(Icons.add) : null,
          trailing: addTrailingIcon ? const Icon(Icons.add) : null,
          child: const Text('Label'),
        ),
      _ButtonType.textSecondary => VoicesTextButton.secondary(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: addLeadingIcon ? const Icon(Icons.add) : null,
          trailing: addTrailingIcon ? const Icon(Icons.add) : null,
          child: const Text('Label'),
        ),
      _ButtonType.icon => VoicesIconButton(
          onTap: state == _ButtonState.disabled ? null : () {},
          child: const Icon(Icons.close),
        ),
      _ButtonType.iconPrimary => VoicesIconButton.primary(
          onTap: state == _ButtonState.disabled ? null : () {},
          child: const Icon(Icons.close),
        ),
      _ButtonType.iconFilled => VoicesIconButton.filled(
          onTap: state == _ButtonState.disabled ? null : () {},
          child: const Icon(Icons.close),
        ),
      _ButtonType.iconTonal => VoicesIconButton.tonal(
          onTap: state == _ButtonState.disabled ? null : () {},
          child: const Icon(Icons.close),
        ),
      _ButtonType.iconOutlined => VoicesIconButton.outlined(
          onTap: state == _ButtonState.disabled ? null : () {},
          child: const Icon(Icons.close),
        ),
    };
  }
}
