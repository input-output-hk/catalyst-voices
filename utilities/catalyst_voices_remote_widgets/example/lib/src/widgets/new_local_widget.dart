import 'package:flutter/material.dart';

class NewLocalWidgets extends StatelessWidget {
  const NewLocalWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 500,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Container(
                  height: 50,
                  color: const Color(0xFF66AACC),
                  child: const Center(child: Text('Entry A')),
                ),
                Container(
                  height: 50,
                  color: const Color(0xFF00FF00),
                  child: const Center(child: Text('Entry B')),
                ),
                Container(
                  height: 50,
                  color: const Color(0xFFFF00FF),
                  child: const Center(child: Text('Entry C')),
                ),
                Container(
                  height: 50,
                  color: const Color(0xFF66AACC),
                  child: const Center(child: Text('Entry D')),
                ),
                Container(
                  height: 50,
                  color: const Color(0xFF00FF00),
                  child: const Center(child: Text('Entry E')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
