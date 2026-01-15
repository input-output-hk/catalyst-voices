import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Base class for signals emitted by [CategoryDetailCubit].
sealed class CategoryDetailSignal extends Equatable {
  const CategoryDetailSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted by [CategoryDetailCubit]. Tells the UI that the category ref has changed.
final class ChangeCategoryRefSignal extends CategoryDetailSignal {
  final DocumentRef? categoryId;

  const ChangeCategoryRefSignal({
    this.categoryId,
  });

  @override
  List<Object?> get props => [categoryId];
}
