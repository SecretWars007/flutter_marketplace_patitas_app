import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../database/database_helper.dart';

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier();
});

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final db = DatabaseHelper.instance;
  return await db.getAllProducts();
});

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  Future<void> loadProducts() async {
    state = await DatabaseHelper.instance.getAllProducts();
  }

  Future<void> addProduct(Product product) async {
    await DatabaseHelper.instance.insertProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await DatabaseHelper.instance.updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);
    await loadProducts();
  }
}
