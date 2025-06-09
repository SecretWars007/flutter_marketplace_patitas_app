import 'package:flutter/material.dart';

class BuyerDashboardScreen extends StatelessWidget {
  const BuyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido al Dashboard de Comprador',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              'Aquí puedes ver novedades, ofertas y tu actividad reciente.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // Aquí puedes agregar más widgets según lo que necesites mostrar
          ],
        ),
      ),
    );
  }
}
