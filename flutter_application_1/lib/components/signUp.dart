import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SignUp Page")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text("Heyyaa"),
              onPressed: () {
                print("Button pressed ✅");
                // (currently it pushes Signup again, better to pop back)
                Navigator.pop(context); // 👈 Goes back to LoginPage
              },
            ),
          ],
        ),
      ),
    );
  }
}
