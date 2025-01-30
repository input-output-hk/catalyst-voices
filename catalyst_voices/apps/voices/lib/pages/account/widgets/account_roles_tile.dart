import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountRolesTile extends StatelessWidget {
  const AccountRolesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountCubit, AccountState, AccountRolesState>(
      selector: (state) => state.roles,
      builder: (context, state) => _AccountRolesTile(state: state),
    );
  }
}

class _AccountRolesTile extends StatelessWidget {
  final AccountRolesState state;

  const _AccountRolesTile({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return PropertyTile(
      title: context.l10n.myRoles,
      action: _EditButton(isEnabled: state.canAddRole),
      child: _Roles(items: state.items),
    );
  }
}

class _EditButton extends StatelessWidget {
  final bool isEnabled;

  const _EditButton({
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      onTap: isEnabled
          ? () {
              // TODO(damian-molinski): registration dialog
            }
          : null,
      child: Text(context.l10n.addRole),
    );
  }
}

class _Roles extends StatelessWidget {
  final List<MyAccountRoleItem> items;

  const _Roles({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((item) => _RoleCell(item: item)).toList(),
    );
  }
}

class _RoleCell extends StatelessWidget {
  final MyAccountRoleItem item;

  const _RoleCell({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final states = <WidgetState>{
      if (!item.isSelected) WidgetState.disabled,
    };

    final colors = context.colors;
    final border = _RoleCellBorder(colors);
    final iconColor = _IconColor(colors);
    final textColor = _TextColor(colors);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: border.resolve(states),
      ),
      child: AffixDecorator(
        prefix: item.type.icon.buildIcon(
          size: 18,
          color: iconColor.resolve(states),
        ),
        child: Text(
          item.type.getName(context, addDefaultState: true),
          style: context.textTheme.labelLarge?.copyWith(
            color: textColor.resolve(states),
          ),
        ),
      ),
    );
  }
}

class _RoleCellBorder implements WidgetStateProperty<Border> {
  final VoicesColorScheme colors;

  const _RoleCellBorder(this.colors);

  @override
  Border resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return Border.all(color: colors.outlineBorderVariant);
    }

    return Border.all(color: colors.outlineBorder);
  }
}

class _IconColor implements WidgetStateProperty<Color> {
  final VoicesColorScheme colors;

  const _IconColor(this.colors);

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return colors.iconsDisabled;
    }

    return colors.iconsForeground;
  }
}

class _TextColor implements WidgetStateProperty<Color> {
  final VoicesColorScheme colors;

  const _TextColor(this.colors);

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return colors.textDisabled;
    }

    return colors.textOnPrimaryLevel0;
  }
}
