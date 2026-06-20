import 'package:flutter/material.dart';
import 'components/signUp.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: const Text("Image"),
                onPressed: () {
                  print("Image button pressed ✅");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ImagePage()),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Signup"),
                onPressed: () {
                  print("Signup button pressed ✅");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: const Text("⬅ Back"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Page")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                print("Image clicked ✅ Navigating...");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImageDetailsPage(),
                  ),
                );
              },
              child: Image.asset("assets/2.png", fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("⬅ Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ImageDetailsPage extends StatelessWidget {
  const ImageDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text Page")),
      body: const Center(
        child: Text(
          "You tapped the image! 🎉",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
