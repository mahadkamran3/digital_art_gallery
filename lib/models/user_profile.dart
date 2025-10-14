class UserProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final String bio;

  UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? bio,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
    );
  }
}
