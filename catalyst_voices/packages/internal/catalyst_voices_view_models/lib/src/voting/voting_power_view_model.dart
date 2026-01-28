import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class VotingPowerViewModel extends Equatable {
  final String amount;
  final VotingPowerStatus? status;
  final DateTime? updatedAt;

  const VotingPowerViewModel({
    this.amount = '---',
    this.status,
    this.updatedAt,
  });

  factory VotingPowerViewModel.fromModel(VotingPower votingPower) {
    return VotingPowerViewModel(
      amount: MoneyFormatter.formatCompactRounded(
        Coin.fromWholeAda(votingPower.amount).toMoney(),
        decoration: MoneyDecoration.symbol,
      ),
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
