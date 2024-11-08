part of 'guidance_cubit.dart';

@immutable
sealed class GuidanceState extends Equatable {}

final class SelectedGuidances extends GuidanceState {
  final List<Guidance> guidances;

  SelectedGuidances(this.guidances);

  @override
  List<Object?> get props => [guidances];
}

final class NoGuidance extends GuidanceState {
  @override
  List<Object?> get props => [];
}
