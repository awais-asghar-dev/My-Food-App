class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
    );
  }
}