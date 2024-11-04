import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
        child: ListView.separated(
          itemBuilder: (context, index) {
            final type = _ButtonType.values[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionText(type.name, key: ObjectKey(type)),
                const SizedBox(height: 16),
                _ButtonRow(type: type),
                if (!type.name.startsWith('icon')) ...[
                  const SizedBox(height: 16),
                  _ButtonRow(type: type, addLeadingIcon: true),
                  const SizedBox(height: 16),
                  _ButtonRow(type: type, addTrailingIcon: true),
                  const SizedBox(height: 16),
                  _ButtonRow(
                    type: type,
                    addLeadingIcon: true,
                    addTrailingText: true,
                  ),
                ],
              ],
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemCount: _ButtonType.values.length,
        ),
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  const _SectionText(
    this.data, {
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      data,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colors.textPrimary,
      ),
      textAlign: TextAlign.start,
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow({
    required this.type,
    this.addLeadingIcon = false,
    this.addTrailingIcon = false,
    this.addTrailingText = false,
  });

  final _ButtonType type;
  final bool addLeadingIcon;
  final bool addTrailingIcon;
  final bool addTrailingText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _ButtonState.values
          .map((state) {
            return _buildButton(
              type,
              state,
              leading: addLeadingIcon ? const Icon(Icons.add) : null,
              trailing: addTrailingIcon
                  ? const Icon(Icons.add)
                  : addTrailingText
                      ? const Text(r'$4.44')
                      : null,
            );
          })
          .separatedBy(const SizedBox(width: 16))
          .toList(),
    );
  }

  Widget _buildButton(
    _ButtonType type,
    _ButtonState state, {
    Widget? leading,
    Widget? trailing,
  }) {
    return switch (type) {
      _ButtonType.filled => VoicesFilledButton(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: leading,
          trailing: trailing,
          child: const Text('Label'),
        ),
      _ButtonType.outlined => VoicesOutlinedButton(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: leading,
          trailing: trailing,
          child: const Text('Label'),
        ),
      _ButtonType.text => VoicesTextButton(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: leading,
          trailing: trailing,
          child: const Text('Label'),
        ),
      _ButtonType.textNeutral => VoicesTextButton.neutral(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: leading,
          trailing: trailing,
          child: const Text('Label'),
        ),
      _ButtonType.textSecondary => VoicesTextButton.secondary(
          onTap: state == _ButtonState.disabled ? null : () {},
          leading: leading,
          trailing: trailing,
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
