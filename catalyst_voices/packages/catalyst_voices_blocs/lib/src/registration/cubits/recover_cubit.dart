// ignore_for_file: one_member_abstracts

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class RecoverManager {
  Future<void> checkLocalKeychains();
}

final class RecoverCubit extends Cubit<RecoverStateData>
    implements RecoverManager {
  RecoverCubit() : super(const RecoverStateData());

  @override
  Future<void> checkLocalKeychains() async {
    // TODO(damian-molinski): Not implemented
  }
}
