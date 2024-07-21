class User {
  final String name;
  final String username;
  final String email;

  User({required this.name, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}
