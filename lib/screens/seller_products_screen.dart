import 'package:flutter/material.dart';

class SellerProductsScreen extends StatelessWidget {
  const SellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí iría la lógica para listar productos y gestionarlos
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text(
          'Lista de Productos del Vendedor',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
