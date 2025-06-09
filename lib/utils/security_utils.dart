import 'dart:convert';
import 'package:crypto/crypto.dart';

class Security {
  /// Encripta una contraseña usando SHA-512 y retorna un hex string.
  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  /// Valida la fortaleza de una contraseña.
  /// Retorna true si cumple con:
  /// - Al menos 8 caracteres
  /// - Al menos una letra mayúscula
  /// - Al menos una letra minúscula
  /// - Al menos un dígito
  /// - Al menos un carácter especial
  static bool validateStrongPassword(String password) {
    final lengthCheck = password.length >= 8;
    final uppercaseCheck = password.contains(RegExp(r'[A-Z]'));
    final lowercaseCheck = password.contains(RegExp(r'[a-z]'));
    final digitCheck = password.contains(RegExp(r'\d'));
    final specialCharCheck = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return lengthCheck &&
        uppercaseCheck &&
        lowercaseCheck &&
        digitCheck &&
        specialCharCheck;
  }
}
