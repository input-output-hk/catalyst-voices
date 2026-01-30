import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class VotingPowerAmount extends Equatable {
  final String formattedWithSymbol;
  final String formatted;

  const VotingPowerAmount({
    required this.formattedWithSymbol,
    required this.formatted,
  });

  const VotingPowerAmount.empty() : formattedWithSymbol = '---', formatted = '---';

  factory VotingPowerAmount.fromModel(int amount) {
    final money = Coin.fromWholeAda(amount).toMoney();
    return VotingPowerAmount(
      formattedWithSymbol: MoneyFormatter.formatCompactRounded(
        money,
        decoration: MoneyDecoration.symbol,
      ),
      formatted: MoneyFormatter.formatCompactRounded(
        money,
        decoration: MoneyDecoration.none,
      ),
    );
  }

  @override
  List<Object?> get props => [formattedWithSymbol, formatted];
}

final class VotingPowerViewModel extends Equatable {
  final VotingPowerAmount amount;
  final VotingPowerStatus? status;
  final DateTime? updatedAt;

  const VotingPowerViewModel({
    this.amount = const VotingPowerAmount.empty(),
    this.status,
    this.updatedAt,
  });

  factory VotingPowerViewModel.fromModel(VotingPower votingPower) {
    return VotingPowerViewModel(
      amount: VotingPowerAmount.fromModel(votingPower.amount),
      status: votingPower.status,
      updatedAt: votingPower.updatedAt,
    );
  }

  factory VotingPowerViewModel.fromSnapshot(Snapshot<VotingPower> snapshot) {
    final votingPower = snapshot.data;
    return votingPower == null
        ? const VotingPowerViewModel()
        : VotingPowerViewModel.fromModel(votingPower);
  }

  /// Merges two voting powers into a total.
  ///
  /// The [status] is going to be provisional if any of the provided statuses is provisional.
  /// The [updatedAt] is going to be the latest provided date.
  factory VotingPowerViewModel.totalFromModels(VotingPower? first, VotingPower? second) {
    final totalAmount = VotingPowerAmount.fromModel(
      (first?.amount ?? 0) + (second?.amount ?? 0),
    );

    final VotingPowerStatus? totalStatus;
    final DateTime? totalUpdatedAt;
    if (first != null && second != null) {
      // If any of the statuses is provisional then total status is provisional too
      totalStatus = [first.status, second.status].contains(VotingPowerStatus.provisional)
          ? VotingPowerStatus.provisional
          : VotingPowerStatus.confirmed;

      // Updated at is the latest date
      totalUpdatedAt = first.updatedAt.isBefore(second.updatedAt)
          ? first.updatedAt
          : second.updatedAt;
    } else if (first != null) {
      totalStatus = first.status;
      totalUpdatedAt = first.updatedAt;
    } else if (second != null) {
      totalStatus = second.status;
      totalUpdatedAt = second.updatedAt;
    } else {
      totalStatus = null;
      totalUpdatedAt = null;
    }

    return VotingPowerViewModel(
      amount: totalAmount,
      status: totalStatus,
      updatedAt: totalUpdatedAt,
    );
  }

  @override
  List<Object?> get props => [amount, status, updatedAt];
}
