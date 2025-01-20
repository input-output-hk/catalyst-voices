import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('BaseProfileCubit');

abstract interface class BaseProfileManager {
  void updateDisplayName(DisplayName value);

  void updateEmail(Email value);
}

final class BaseProfileCubit extends Cubit<BaseProfileStateData>
    with BlocErrorEmitterMixin
    implements BaseProfileManager {
  BaseProfileCubit() : super(const BaseProfileStateData());

  @override
  void updateDisplayName(DisplayName value) {
    emit(state.copyWith(displayName: value));
  }

  @override
  void updateEmail(Email value) {
    emit(state.copyWith(email: value));
  }
}
