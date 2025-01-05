class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String password;

  UserModel({required this.id, required this.name, required this.email, required this.avatarUrl, required this.password});

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}
