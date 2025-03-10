import 'package:catalyst_voices/pages/account/widgets/account_display_name_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_roles_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/constants.dart';

class ProfilePage {
  ProfilePage(this.$);
  late PatrolTester $;
  final displayNameTile = const Key('AccountDisplayNameTile');
  final accountEmailTile = const Key('AccountEmailTile');
  final editBtn = const Key('EditableTileEditSaveButton');
  final accountRolesTile = const Key('AddRoleTile');
  final addRole= const Key('EditRolesButton');
  final removeKeychain = const Key('RemoveKeychainButton');



  Future<void> clickDisplayNameEdit() async {
    await $(displayNameTile).$(editBtn).tap();  
  }

  Future<void> clickEmailAdressEdit() async {

    await $(accountEmailTile).$(editBtn).tap();

  }

  Future<void> addRoleClick() async {
    
    await $(accountRolesTile).$(addRole).tap();
  }

  Future<void> removeKeychainClick() async {
    await $(removeKeychain).tap();

  }

}
