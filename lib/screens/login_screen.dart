import 'package:flutter/material.dart';
import 'package:flutter_marketplace_patitas_app/screens/buyer_home_screen.dart';
import 'package:flutter_marketplace_patitas_app/screens/seller_home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;
  String _error = '';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = '';
    });

    final success = await ref
        .read(authProvider.notifier)
        .login(_emailCtrl.text.trim(), _passwordCtrl.text.trim());

    if (success) {
      final user = ref.read(authProvider);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user!.id!);

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
    } else {
      setState(() {
        _error = 'Correo o contraseña incorrectos';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Padding(
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
                          value!.isEmpty ? 'Ingrese su contraseña' : null,
                ),
                const SizedBox(height: 20),
                if (_error.isNotEmpty)
                  Text(_error, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child:
                      _loading
                          ? const CircularProgressIndicator()
                          : const Text('Ingresar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
