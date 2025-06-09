import 'package:flutter/material.dart';
import 'package:flutter_marketplace_patitas_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productNotifier = ref.read(productProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          widget.product == null ? 'Agregar Producto' : 'Editar Producto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Campo requerido';
                  if (double.tryParse(val) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final product = Product(
                    id: widget.product?.id,
                    name: _nameController.text.trim(),
                    price: double.parse(_priceController.text.trim()),
                    userId: ref.read(authProvider)?.id ?? 0,
                  );

                  if (widget.product == null) {
                    await productNotifier.addProduct(product);
                  } else {
                    await productNotifier.updateProduct(product);
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: Text(widget.product == null ? 'Guardar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
