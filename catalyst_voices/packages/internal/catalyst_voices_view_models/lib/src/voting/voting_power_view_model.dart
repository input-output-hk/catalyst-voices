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
    return VotingPowerAmount(
      formattedWithSymbol: MoneyFormatter.formatCompactRounded(
        Coin.fromWholeAda(amount).toMoney(),
        decoration: MoneyDecoration.symbol,
      ),
      formatted: MoneyFormatter.formatCompactRounded(
        Coin.fromWholeAda(amount).toMoney(),
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

  @override
  List<Object?> get props => [amount, status, updatedAt];
}
