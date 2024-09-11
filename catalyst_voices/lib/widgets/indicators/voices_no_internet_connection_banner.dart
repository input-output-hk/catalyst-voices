import 'package:flutter/material.dart';

class NoInternetConnectionBanner extends StatelessWidget {
  final VoidCallback onRefresh;

  const NoInternetConnectionBanner({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No internet connection',
            style: TextStyle(
              color: Colors.white,   

              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: onRefresh,
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                color: Colors.white
              ),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}