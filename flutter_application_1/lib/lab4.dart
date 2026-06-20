import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Product Listing'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: const <Widget>[
          ProductBox(
            name: "iPhone",
            description: "iPhone is the stylist phone ever",
            price: 1000,
            color: Colors.purple,
          ),
          ProductBox(
            name: "Pixel",
            description: "Pixel is the most featureful phone ever",
            price: 800,
            color: Colors.blue,
          ),
          ProductBox(
            name: "Laptop",
            description: "Laptop is most productive development tool",
            price: 2000,
            color: Colors.green,
          ),
          ProductBox(
            name: "Tablet",
            description: "Tablet is the most useful device ever for meeting",
            price: 1500,
            color: Colors.amber,
          ),
          ProductBox(
            name: "Pendrive",
            description: "Pendrive is useful storage medium",
            price: 100,
            color: Colors.brown,
          ),
        ],
      ),
    );
  }
}

class ProductBox extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final Color color;

  const ProductBox({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 120,
      child: Card(
        elevation: 3,
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: double.infinity,
              color: color,
              child: Center(
                child: Text(
                  name.toLowerCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(description),
                    const SizedBox(height: 6),
                    Text(
                      "Price: $price",
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
