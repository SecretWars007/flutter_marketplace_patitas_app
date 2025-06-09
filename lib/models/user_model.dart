class User {
  final int? id;
  final String email;
  final String password;
  final int roleId;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.roleId,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password, 'role_id': roleId};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      roleId: map['role_id'],
    );
  }

  // ✅ Agregado para permitir actualizar campos específicos (como id)
  User copyWith({int? id, String? email, String? password, int? roleId}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      roleId: roleId ?? this.roleId,
    );
  }
}
