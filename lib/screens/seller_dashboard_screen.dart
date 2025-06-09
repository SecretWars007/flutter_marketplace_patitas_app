import 'package:flutter/material.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text(
          'Bienvenido al Panel del Vendedor',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
