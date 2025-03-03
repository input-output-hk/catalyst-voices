import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

class CommonPage {
  CommonPage(this.$);

  late PatrolTester $;
  final decorData = const Key('DecoratorData');
  final decorIconBefore = const Key('DecoratorIconBefore');
  final decorIconAfter = const Key('DecoratorIconAfter');
  final dialogCloseButton = const Key('DialogCloseButton');
  final voicesTextField = const Key('VoicesTextField');
  final navigationBackBtn = const Key('NavigationBackBtn');
  final paginationText = const Key('PaginationText');
  final prevPageBtn = const Key('PrevPageBtn');
  final nextPageBtn = const Key('NextPageBtn');
}
