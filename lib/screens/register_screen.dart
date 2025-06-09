import 'package:flutter/material.dart';
import 'package:flutter_marketplace_patitas_app/screens/buyer_home_screen.dart';
import 'package:flutter_marketplace_patitas_app/screens/seller_home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_model.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _role = 'buyer';
  String _error = '';
  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = '';
    });

    final success = await ref
        .read(authProvider.notifier)
        .register(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
          roleName: _role,
        );

    if (success) {
      final user = ref.read(authProvider);
      if (user != null) {
        // Insertar el perfil del usuario
        final profile = Profile(
          userId: user.id!,
          name: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          photo: '', // se puede actualizar luego desde la cámara o galería
        );
        await ref.read(profileProvider.notifier).createProfile(profile);

        // Guardar sesión
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user.id!);

        // Redirigir según el rol
        if (user.roleId == 1) {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (_) => const BuyerHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (_) => const SellerHomeScreen()),
          );
        }
      }
    } else {
      setState(() {
        _error = 'El correo ya está registrado';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese su correo' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator:
                    (value) =>
                        value!.length < 6
                            ? 'Debe tener al menos 6 caracteres'
                            : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese su teléfono' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(labelText: 'Rol'),
                items: const [
                  DropdownMenuItem(value: 'buyer', child: Text('Comprador')),
                  DropdownMenuItem(value: 'seller', child: Text('Vendedor')),
                ],
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_error.isNotEmpty)
                Text(_error, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loading ? null : _register,
                child:
                    _loading
                        ? const CircularProgressIndicator()
                        : const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
