import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Productos Disponibles'),
      ),
      body: productsAsync.when(
        data:
            (products) =>
                products.isEmpty
                    ? const Center(child: Text('No hay productos disponibles'))
                    : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        final p = products[i];
                        return ListTile(
                          title: Text(p.name),
                          subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                        );
                      },
                    ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
