class Profile {
  int? id;
  int userId;
  String? name;
  String? phone;
  String? photo; // Ruta o base64 de la foto

  Profile({this.id, required this.userId, this.name, this.phone, this.photo});

  // Convertir un Map de la base de datos a un objeto Profile
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      name: map['name'] as String?,
      phone: map['phone'] as String?,
      photo: map['photo'] as String?,
    );
  }

  // Convertir un objeto Profile a un Map para insertar o actualizar en DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'photo': photo,
    };
  }
}
