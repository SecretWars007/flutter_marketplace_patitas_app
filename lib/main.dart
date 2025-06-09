import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/buyer_home_screen.dart';
import 'screens/seller_home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/buyer_home': (_) => const BuyerHomeScreen(),
        '/seller_home': (_) => const SellerHomeScreen(),
        '/product_list': (_) => const ProductListScreen(),
        '/product_form': (_) => const ProductFormScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
