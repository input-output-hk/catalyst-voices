part of 'main.dart';

Future<void> _signData({
  required BuildContext context,
  required CardanoWalletApi api,
}) async {
  var result = '';

  try {
    final addresses = await api.getUsedAddresses();
    final signature = await api.signData(
      address: addresses.first,
      payload: 'hello world!'.codeUnits,
    );

    result = 'Signature: $signature';
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
