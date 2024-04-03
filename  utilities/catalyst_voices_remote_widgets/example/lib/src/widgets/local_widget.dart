import 'package:flutter/material.dart';

class LocalWidget extends StatelessWidget {
  const LocalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 350,
        width: 500,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF66AACC),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'First Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 24),
                const Text(
                  'Second Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextField(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFF1F09),
                  ),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
