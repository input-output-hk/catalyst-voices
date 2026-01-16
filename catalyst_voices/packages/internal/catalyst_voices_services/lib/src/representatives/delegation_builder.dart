import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class DelegationBuilder {
  int get count;

  int get maxCount;

  List<Representative> get representatives;

  Stream<List<Representative>> get watch;

  void add(Representative rep);

  Future<Delegation> build();

  void dispose();

  void remove(Representative rep);
}
