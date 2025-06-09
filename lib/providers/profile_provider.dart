import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/profile_model.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<Profile?>>((ref) {
      return ProfileNotifier();
    });

class ProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  ProfileNotifier() : super(const AsyncValue.loading());

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> loadProfile(int userId) async {
    try {
      state = const AsyncValue.loading();
      final profile = await _dbHelper.getProfileByUserId(userId);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createProfile(Profile profile) async {
    try {
      await _dbHelper.insertProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      await _dbHelper.updateProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Método para crear o actualizar según exista el perfil.
  Future<void> saveProfile(Profile profile) async {
    try {
      state = const AsyncValue.loading();
      final existingProfile = await _dbHelper.getProfileByUserId(
        profile.userId,
      );
      if (existingProfile == null) {
        await _dbHelper.insertProfile(profile);
      } else {
        await _dbHelper.updateProfile(profile);
      }
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Método para obtener el perfil actual del estado (sincrónico).
  Profile? getProfile(param0) {
    return state.maybeWhen(data: (profile) => profile, orElse: () => null);
  }
}
