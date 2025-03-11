import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

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
