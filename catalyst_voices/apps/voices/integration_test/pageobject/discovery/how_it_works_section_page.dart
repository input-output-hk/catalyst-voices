import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import '../../utils/translations_utils.dart';

class HowItWorksSection {
  HowItWorksSection(this.$);

  late PatrolTester $;
  final title = const Key('HowItWorksTitle');
  final collaborateAvatar = const Key('collaborateAvatar');
  final collaborateTitle = const Key('collaborateTitle');
  final collaborateDescription = const Key('collaborateDescription');
  final voteAvatar = const Key('voteAvatar');
  final voteTitle = const Key('voteTitle');
  final voteDescription = const Key('voteDescription');
  final followAvatar = const Key('followAvatar');
  final followTitle = const Key('followTitle');
  final followDescription = const Key('followDescription');
  final loadingError = const Key('ErrorIndicator');
  final howItWorksRoot = const Key('HowItWorks');

  Future<void> titleIsRenderedCorrectly() async {
    expect($(title).text, T.get('Here’s how it works'));
  }

  Future<void> collaborateAvatarIsRenderedCorrectly() async {
    expect($(collaborateAvatar), findsOneWidget);
  }

  Future<void> collaborateTitleIsRenderedCorrectly() async {
    expect($(collaborateTitle).text, T.get('Innovate together'));
  }

  Future<void> collaborateDescriptionIsRenderedCorrectly() async {
    expect(
      $(collaborateDescription).text,
      T.get('Got an Idea? Create an impactful '
          'proposal and collaborate with the community to develop and refine '
          'it.'),
    );
  }

  Future<void> voteAvatarIsRenderedCorrectly() async {
    expect($(voteAvatar), findsOneWidget);
  }

  Future<void> voteTitleIsRenderedCorrectly() async {
    expect($(voteTitle).text, T.get('Vote for your favorite ideas'));
  }

  Future<void> voteDescriptionIsRenderedCorrectly() async {
    expect(
      $(voteDescription).text,
      T.get('Use a voting app to choose ideas with impact worth funding. Get '
          'rewarded in ada for taking part.'),
    );
  }

  Future<void> followAvatarIsRenderedCorrectly() async {
    expect($(followAvatar), findsOneWidget);
  }

  Future<void> followTitleIsRenderedCorrectly() async {
    expect($(followTitle).text, T.get('Stay up to date'));
  }

  Future<void> followDescriptionIsRenderedCorrectly() async {
    expect(
      $(followDescription).text,
      T.get('Receive regular updates on all the funded ideas, so you can '
          'follow along and see how things are progressing.'),
    );
  }

  Future<void> loadingErrorIsVisible() async {
    expect($(howItWorksRoot).$(loadingError), findsOneWidget);
  }

  Future<void> looksAsExpectedForVisitor() async {
    await titleIsRenderedCorrectly();
    await collaborateAvatarIsRenderedCorrectly();
    await collaborateTitleIsRenderedCorrectly();
    await collaborateDescriptionIsRenderedCorrectly();
    await voteAvatarIsRenderedCorrectly();
    await voteTitleIsRenderedCorrectly();
    await voteDescriptionIsRenderedCorrectly();
    await followAvatarIsRenderedCorrectly();
    await followTitleIsRenderedCorrectly();
    await followDescriptionIsRenderedCorrectly();
  }
}
