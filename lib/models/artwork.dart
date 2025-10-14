class Artwork {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final String artistName;
  final DateTime createdAt;
  final Set<String> likedBy;
  final int likesCount;
  final int commentsCount;

  Artwork({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.artistName,
    required this.createdAt,
    this.likedBy = const {},
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  Artwork copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    String? artistName,
    DateTime? createdAt,
    Set<String>? likedBy,
    int? likesCount,
    int? commentsCount,
  }) {
    return Artwork(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      artistName: artistName ?? this.artistName,
      createdAt: createdAt ?? this.createdAt,
      likedBy: likedBy ?? this.likedBy,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
