import 'package:flutter/material.dart';

class MoreDetailsPage extends StatelessWidget {
  const MoreDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Details'),
      ),
      body: const Center(
        child: Text('More details about the player.'),
      ),
    );
  }
}