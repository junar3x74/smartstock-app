import 'package:flutter/material.dart';
import 'products.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductPage()),
            );
          },
          child: Text('View Products'),
        ),
      ),
    );
  }
}
