part of 'main.dart';

Future<void> _signData({
  required BuildContext context,
  required CardanoWalletApi api,
}) async {
  var result = '';

  try {
    final rewardAddress = await api.getRewardAddresses();
    final signer = await api.signData(
      address: rewardAddress.first,
      payload: [1, 2, 3],
    );

    result = 'Signature: ${hex.encode(cbor.encode(signer.toCbor()))}';
  } catch (error) {
    result = error.toString();
  }

  if (context.mounted) {
    await _showDialog(
      context: context,
      title: 'Sign data',
      message: result,
    );
  }
}
