import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/comment.dart';

class InteractionsProvider extends ChangeNotifier {
  final Map<String, List<Comment>> _comments = {};
  final Map<String, Set<String>> _likes = {};
  final String _currentUserId = 'user_1';
  final String _currentUserName = 'Demo User';

  String get currentUserId => _currentUserId;
  String get currentUserName => _currentUserName;

  List<Comment> getCommentsForArtwork(String artworkId) {
    return _comments[artworkId] ?? [];
  }

  Set<String> getLikesForArtwork(String artworkId) {
    return _likes[artworkId] ?? {};
  }

  bool isArtworkLikedByCurrentUser(String artworkId) {
    return _likes[artworkId]?.contains(_currentUserId) ?? false;
  }

  int getLikesCount(String artworkId) {
    return _likes[artworkId]?.length ?? 0;
  }

  int getCommentsCount(String artworkId) {
    return _comments[artworkId]?.length ?? 0;
  }

  Future<void> toggleLike(String artworkId) async {
    _likes[artworkId] ??= {};

    if (_likes[artworkId]!.contains(_currentUserId)) {
      _likes[artworkId]!.remove(_currentUserId);
    } else {
      _likes[artworkId]!.add(_currentUserId);
    }

    await _saveLikes();
    notifyListeners();
  }

  Future<void> addComment(String artworkId, String text) async {
    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      artworkId: artworkId,
      userId: _currentUserId,
      userName: _currentUserName,
      text: text,
      createdAt: DateTime.now(),
    );

    _comments[artworkId] ??= [];
    _comments[artworkId]!.add(comment);

    await _saveComments();
    notifyListeners();
  }

  Future<void> removeComment(String artworkId, String commentId) async {
    _comments[artworkId]?.removeWhere((comment) => comment.id == commentId);
    await _saveComments();
    notifyListeners();
  }

  Future<void> loadData() async {
    await _loadLikes();
    await _loadComments();
  }

  Future<void> _saveLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final likesMap = <String, List<String>>{};

    _likes.forEach((artworkId, likes) {
      likesMap[artworkId] = likes.toList();
    });

    await prefs.setString('artwork_likes', jsonEncode(likesMap));
  }

  Future<void> _loadLikes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likesString = prefs.getString('artwork_likes');

      if (likesString != null) {
        final likesMap = Map<String, dynamic>.from(jsonDecode(likesString));

        _likes.clear();
        likesMap.forEach((artworkId, likes) {
          _likes[artworkId] = Set<String>.from(List<String>.from(likes));
        });
      }
    } catch (e) {
      debugPrint('Error loading likes: $e');
    }
  }

  Future<void> _saveComments() async {
    final prefs = await SharedPreferences.getInstance();
    final commentsMap = <String, List<Map<String, dynamic>>>{};

    _comments.forEach((artworkId, comments) {
      commentsMap[artworkId] = comments
          .map((comment) => comment.toMap())
          .toList();
    });

    await prefs.setString('artwork_comments', jsonEncode(commentsMap));
  }

  Future<void> _loadComments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final commentsString = prefs.getString('artwork_comments');

      if (commentsString != null) {
        final commentsMap = Map<String, dynamic>.from(
          jsonDecode(commentsString),
        );

        _comments.clear();
        commentsMap.forEach((artworkId, commentsList) {
          _comments[artworkId] = List<Comment>.from(
            List<Map<String, dynamic>>.from(
              commentsList,
            ).map((commentMap) => Comment.fromMap(commentMap)),
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading comments: $e');
    }
  }
}
