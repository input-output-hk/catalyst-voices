import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/translations_utils.dart';
import 'common_page.dart';

class ProfilePage {
  ProfilePage(this.$);
  late PatrolTester $;
  final displayNameTile = const Key('AccountDisplayNameTile');
  final accountEmailTile = const Key('AccountEmailTile');
  final editBtn = const Key('EditableTileEditSaveButton');
  final accountRolesTile = const Key('AddRoleTile');
  final addRole = const Key('EditRolesButton');
  final removeKeychain = const Key('RemoveKeychainButton');
  final accDisplayNameTxtField = const Key('AccountDisplayNameTextField');
  final accountKeychainTxtField = const Key('AccountKeychainTextField');
  final accountPageTitle = const Key('AccountPageTitle');
  final navigationBackBtn = const Key('NavigationBackBtn');
  final accountAvatar = const Key('AccountAvatar');
  final toolTip = const Key('Tooltip');
  final accountKeychainTile = const Key('AccountKeychainTile');
  final startProposalBtn = const Key('StartProposalBtn');
  final lockButton = const Key('LockButton');
  final appBarProfileAvatar = const Key('ProfileAvatar');
  final profileAndKeychainText = const Key('ProfileAndKeychainText');
  final accountEmailTextField = const Key('AccountEmailTextField');
  final emailTileSaveBtn = const Key('EmailTileSaveButton');
  final deleteKeychainContinueButton = 
  const Key('DeleteKeychainContinueButton');
  final deleteKeychainTextField = const Key('DeleteKeychainTextField');
  final keychainDeletedDialogCloseButton =
      const Key('KeychainDeletedDialogCloseButton');
  Future<void> clickDisplayNameEdit() async {
    await $(displayNameTile).$(editBtn).tap();
  }

  Future<void> clickEmailAddressEdit() async {
    await $(accountEmailTile).$(editBtn).tap();
  }

  Future<void> addRoleClick() async {
    await $(accountRolesTile).$(addRole).tap();
  }

  Future<void> removeKeychainClick() async {
    await $(removeKeychain).tap();
  }

  Future<void> verifyPageElements() async {

    expect(
      $(profileAndKeychainText).text,
      (await t()).profileAndKeychain,
    );
    expect(
      $(navigationBackBtn),
      findsOneWidget,
    );
    expect(
      $(accountAvatar),
      findsOneWidget,
    );
    expect(
      $(toolTip),
      findsOneWidget,
    );
    expect(
      $(displayNameTile),
      findsOneWidget,
    );
    expect(
      $(accountEmailTile),
      findsOneWidget,
    );
    expect(
      $(accountRolesTile),
      findsOneWidget,
    );
    expect(
      $(accountKeychainTile),
      findsOneWidget,
    );
    expect(
      $(startProposalBtn),
      findsOneWidget,
    );
    expect(
      $(lockButton),
      findsOneWidget,
    );
    expect(
      $(appBarProfileAvatar),
      findsOneWidget,
    );
  }

  Future<void> displayNameIsAsExpected(String expectedDisplayName) async {
    final textField = $(accDisplayNameTxtField)
        .$(CommonPage($).voicesTextField)
        .evaluate()
        .first
        .widget as TextField;

    expect(textField.controller!.text, expectedDisplayName);
  }

  Future<void> emailIsAsExpected(String expectedEmail) async {
    final textField = $(accountEmailTile)
        .$(CommonPage($).voicesTextField)
        .evaluate()
        .first
        .widget as TextField;

    expect(textField.controller!.text, expectedEmail);
  }

  Future<void> keychainIsAsExpected(String expectedKeychain) async {
    final textField = $(accountKeychainTxtField)
        .$(CommonPage($).voicesTextField)
        .evaluate()
        .first
        .widget as TextField;

    expect(textField.controller!.text, expectedKeychain);
  }
}
