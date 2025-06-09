class Product {
  final int? id;
  final int userId;
  final String name;
  final String? description;
  final double price;
  final String? image; // ruta o base64

  Product({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.price,
    this.image,
  });

  // Convertir de Map (de la DB) a objeto Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      price:
          map['price'] is int
              ? (map['price'] as int).toDouble()
              : map['price'] as double,
      image: map['image'] as String?,
    );
  }

  // Convertir objeto Product a Map para insertar/actualizar en DB
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'user_id': userId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
