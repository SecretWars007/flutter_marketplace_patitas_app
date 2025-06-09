import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile_model.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = ref.read(authProvider);
    if (user != null) {
      final profile = ref.read(profileProvider.notifier).getProfile(user.id!);
      if (profile != null) {
        _nameController.text = profile.name ?? '';
        _phoneController.text = profile.phone ?? '';
        setState(() {
          _photoPath = profile.photo;
        });
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authProvider);
      if (user != null) {
        final profile = Profile(
          userId: user.id!,
          name: _nameController.text,
          phone: _phoneController.text,
          photo: _photoPath,
        );

        await ref.read(profileProvider.notifier).createProfile(profile);

        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text('Perfil guardado')));
      } else {
        // Opcional: manejar el caso cuando user es null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: usuario no encontrado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Perfil de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _photoPath != null
                            ? FileImage(File(_photoPath!))
                            : null,
                    child:
                        _photoPath == null
                            ? const Icon(Icons.camera_alt, size: 40)
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese un nombre'
                            : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese un teléfono'
                            : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Guardar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
