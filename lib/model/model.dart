class User {
  int id;
  String name, username, email, avatar;
  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        avatar: json['avatar']);
  }
}
