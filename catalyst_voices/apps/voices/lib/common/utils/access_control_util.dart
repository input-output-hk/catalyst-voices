import 'package:catalyst_voices/common/ext/map_ext.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class AccessControlUtil {
  static const defaultSpacesAccess = [Space.discovery];

  static const List<Space> _votingAccess = [
    Space.discovery,
    Space.voting,
    Space.fundedProjects,
  ];

  static const List<Space> _proposalAccess = [
    Space.discovery,
    Space.workspace,
    Space.voting,
    Space.fundedProjects,
  ];

  static const List<Space> _adminAccess = [
    Space.discovery,
    Space.workspace,
    Space.treasury,
    Space.voting,
    Space.fundedProjects,
  ];

  static final Map<Space, LogicalKeySet> allSpacesShortcutsActivators = {
    Space.discovery:
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit1),
    Space.workspace:
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit2),
    Space.voting:
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit3),
    Space.fundedProjects:
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit4),
    Space.treasury:
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyT),
  };

  static bool _hasProposerOrDrepRole(Account account) {
    return account.roles
        .any((role) => [AccountRole.proposer, AccountRole.drep].contains(role));
  }

  static List<Space> spacesAccess(Account? account) {
    if (account == null) return defaultSpacesAccess;
    if (account.isAdmin) return Space.values;
    if (_hasProposerOrDrepRole(account)) {
      // TODO(ryszard.schossler): After F14 use _proposalAccess
      return [Space.discovery, Space.workspace];
    }

    // TODO(ryszard.schossler): After F14 use _votingAccess
    return defaultSpacesAccess;
  }

  static Map<Space, ShortcutActivator> spacesShortcutsActivators(
    Account? account,
  ) {
    if (account == null) {
      return allSpacesShortcutsActivators.useKeys([Space.discovery]);
    }
    if (account.isAdmin) return allSpacesShortcutsActivators;
    if (_hasProposerOrDrepRole(account)) {
      return allSpacesShortcutsActivators.useKeys([
        Space.discovery,
        Space.workspace,
        // TODO(ryszard.schossler): After F14 add Space.voting and Space.fundedProjects
        // OR use values from _proposalAccess
      ]);
    }
    return allSpacesShortcutsActivators.useKeys([Space.discovery]);
  }

  static List<Space> overallSpaces(Account? account) {
    if (account == null) return _votingAccess;
    if (account.isAdmin) return _adminAccess;
    if (_hasProposerOrDrepRole(account)) return _proposalAccess;
    return _votingAccess;
  }
}
