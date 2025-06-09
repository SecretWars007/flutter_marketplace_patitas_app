import 'package:flutter_marketplace_patitas_app/database/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';
import '../utils/security_utils.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier(this.ref) : super(null);

  final Ref ref;
  final dbHelper = DatabaseHelper();
  final security = Security();
  User? _user;
  Profile? _profile;

  Future<bool> register({
    required String email,
    required String password,
    required String roleName,
  }) async {
    final db = await dbHelper.database;

    // Verificar si el usuario ya existe
    final existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUser.isNotEmpty) return false;

    // Obtener ID del rol
    final role = await db.query(
      'roles',
      where: 'name = ?',
      whereArgs: [roleName],
    );

    if (role.isEmpty) return false;

    final roleId = role.first['id'] as int;

    // Crear el nuevo usuario
    final user = User(
      email: email,
      password: Security.encryptPassword(password),
      roleId: roleId,
    );

    final userId = await db.insert('users', user.toMap());
    _user = user.copyWith(id: userId);
    state = _user;

    // Crear perfil vacío al registrar
    final profile = Profile(userId: userId, name: '', phone: '', photo: '');
    await dbHelper.insertProfile(profile);
    _profile = profile;

    return true;
  }

  Future<bool> login(String email, String password) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, Security.encryptPassword(password)],
    );

    if (result.isNotEmpty) {
      _user = User.fromMap(result.first);
      state = _user;

      // Cargar perfil del usuario al hacer login
      _profile = await dbHelper.getProfileByUserId(_user!.id!);

      // Opcional: si usas un provider para profile, puedes notificarlo aquí con ref.read o ref.watch

      return true;
    }

    return false;
  }

  void logout() {
    _user = null;
    _profile = null;
    state = null;
  }

  User? get currentUser => _user;
  Profile? get currentProfile => _profile;
}
