import 'package:flutter/material.dart';

class AccountStatusBanner extends StatelessWidget {
  const AccountStatusBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(height: 20),
      color: Colors.yellow,
      child: Text('QQQ'),
    );
  }
}
