import 'package:flutter/material.dart';

class CongratulationPage extends StatelessWidget {
  final String message;
  final VoidCallback? onNext;

  const CongratulationPage({
    super.key,
    this.message = "You solved the puzzle!",
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎉 Congratulations!")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon removed
            const SizedBox(height: 20), // keeps spacing consistent
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onNext ?? () => Navigator.pop(context),
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
