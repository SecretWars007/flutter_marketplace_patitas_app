import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart'; // Ajusta la ruta según tu proyecto
import 'buyer_products_screen.dart';
import 'buyer_dashboard_screen.dart';
import 'profile_screen.dart';

class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends ConsumerState<BuyerHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BuyerDashboardScreen(),
    BuyerProductsScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = ['Inicio', 'Productos', 'Perfil'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    ref.read(authProvider.notifier).logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
        backgroundColor: Colors.amber,
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
