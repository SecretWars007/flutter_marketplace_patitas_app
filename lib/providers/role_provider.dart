import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/role_model.dart';
import 'database_provider.dart';

final rolesProvider = FutureProvider<List<Role>>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.getAllRoles();
});

final roleByNameProvider = FutureProvider.family<Role?, String>((
  ref,
  roleName,
) async {
  final db = ref.read(databaseProvider);
  return await db.getRoleByName(roleName);
});
