class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String password;
  final String? bio;

  UserModel({required this.id, required this.name, required this.email, this.avatarUrl, required this.password, this.bio});

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['username'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      password: data['password'] ?? '',
      bio: data['bio'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
    };
  }
}
