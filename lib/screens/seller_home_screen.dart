import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart'; // Ajusta la ruta según tu proyecto
import 'profile_screen.dart';
import 'seller_products_screen.dart';
import 'seller_dashboard_screen.dart';

class SellerHomeScreen extends ConsumerStatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  ConsumerState<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends ConsumerState<SellerHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SellerDashboardScreen(),
    SellerProductsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = ['Inicio', 'Productos', 'Perfil'];

  void _logout() {
    ref.read(authProvider.notifier).logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Productos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
