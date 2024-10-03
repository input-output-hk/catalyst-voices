import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountPopup extends StatelessWidget {
  final String avatarLetter;
  final VoidCallback? onProfileKeychainTap;
  final VoidCallback? onLockAccountTap;

  const AccountPopup({
    super.key,
    required this.avatarLetter,
    this.onProfileKeychainTap,
    this.onLockAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuItemValue>(
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      onSelected: (_MenuItemValue value) {
        switch (value) {
          case _MenuItemValue.profileAndKeychain:
            onProfileKeychainTap?.call();
            break;
          case _MenuItemValue.lock:
            onLockAccountTap?.call();
            break;
        }
      },
      itemBuilder: (BuildContext bc) {
        return [
          PopupMenuItem(
            padding: EdgeInsets.zero,
            enabled: false,
            value: null,
            child: _Header(
              accountLetter: avatarLetter,
              walletName: 'Wallet name',
              walletBalance: '₳ 1,750,000',
              accountType: 'Basis',
              /* cSpell:disable */
              walletAddress: ShelleyAddress.fromBech32(
                'addr_test1vzpwq95z3xyum8vqndgdd'
                '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
              ),
              /* cSpell:enable */
            ),
          ),
          const PopupMenuItem(
            height: 48,
            padding: EdgeInsets.zero,
            enabled: false,
            value: null,
            child: _Section('My account'),
          ),
          PopupMenuItem(
            padding: EdgeInsets.zero,
            value: _MenuItemValue.profileAndKeychain,
            child: _MenuItem(
              'Profile & Keychain',
              VoicesAssets.icons.userCircle,
            ),
          ),
          PopupMenuItem(
            padding: EdgeInsets.zero,
            value: _MenuItemValue.lock,
            child: _MenuItem(
              'Lock account',
              VoicesAssets.icons.lockClosed,
              showDivider: false,
            ),
          ),
        ];
      },
      offset: const Offset(0, kToolbarHeight),
      child: IgnorePointer(
        child: VoicesAvatar(
          icon: Text(avatarLetter),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String accountLetter;
  final String walletName;
  final String walletBalance;
  final String accountType;
  final ShelleyAddress walletAddress;

  const _Header({
    required this.accountLetter,
    required this.walletName,
    required this.walletBalance,
    required this.accountType,
    required this.walletAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _padding),
          child: Row(
            children: [
              VoicesAvatar(
                icon: Text(accountLetter),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(_padding),
                  child: Wrap(
                    children: [
                      Text(
                        walletName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        walletBalance,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              VoicesChip.rectangular(
                content: Text(
                  accountType,
                  style: TextStyle(
                    color: Theme.of(context).colors.successContainer,
                  ),
                ),
                backgroundColor: Theme.of(context).colors.success,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: _padding,
            right: _padding,
            bottom: _padding,
            top: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  WalletAddressFormatter.formatShort(walletAddress),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              InkWell(
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(text: walletAddress.toBech32()),
                  );
                },
                child: VoicesAssets.icons.clipboardCopy.buildIcon(),
              ),
            ],
          ),
        ),
        VoicesDivider(
          height: 1,
          color: Theme.of(context).colors.outlineBorder,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String text;
  final SvgGenImage icon;
  final bool showDivider;

  const _MenuItem(
    this.text,
    this.icon, {
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 47,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: _padding),
          child: Row(
            children: [
              icon.buildIcon(),
              const SizedBox(width: _padding),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        if (showDivider)
          VoicesDivider(
            height: 1,
            color: Theme.of(context).colors.outlineBorderVariant,
            indent: 0,
            endIndent: 0,
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String text;

  const _Section(
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 47,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: _padding),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        VoicesDivider(
          height: 1,
          color: Theme.of(context).colors.outlineBorderVariant,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}

const _padding = 12.0;

enum _MenuItemValue {
  profileAndKeychain,
  lock,
}
