import 'package:flutter/material.dart';

class LocalWidget extends StatelessWidget {
  const LocalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 300,
        width: 500,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Local Widget',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF66AACC),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'First Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Second Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextField(
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFF1F09),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
