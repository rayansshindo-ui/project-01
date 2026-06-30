// lib/models/user_model.dart

class AppUser {
  final String id;
  final String username;
  final String email;
  final String avatarUrl;
  final List<String> friendsIds;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.friendsIds,
  });

  // Convertir les données Firebase (JSON) en objet utilisable dans le code
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      username: json['username'] ?? 'Anonyme',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? 'https://via.placeholder.com/150',
      friendsIds: List<String>.from(json['friendsIds'] ?? []),
    );
  }

  // Convertir l'objet en JSON pour l'envoyer vers la base de données
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'friendsIds': friendsIds,
    };
  }
}