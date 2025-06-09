import 'package:flutter/material.dart';

class BuyerProductsScreen extends StatelessWidget {
  const BuyerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí podrías integrar lógica para listar productos del marketplace
    // con un ConsumerWidget o ref.read para acceder a datos si usas Riverpod.

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text(
          'Lista de productos para compradores',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
