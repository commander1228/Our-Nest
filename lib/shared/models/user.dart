class User {
  final String id;
  final String? name;
  final String? email;

  User({required this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String?,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      };
}