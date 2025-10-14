import 'package:flutter/material.dart';
import '../models/artwork.dart';
import '../models/user_profile.dart';

class GalleryProvider extends ChangeNotifier {
  final List<Artwork> _artworks = [];
  UserProfile _user = UserProfile(
    id: '1',
    name: 'Demo Artist',
    avatarUrl: '',
    bio: 'Digital artist and enthusiast.',
  );

  List<Artwork> get artworks => List.unmodifiable(_artworks);
  UserProfile get user => _user;

  void uploadArtwork(Artwork artwork) {
    _artworks.insert(0, artwork);
    notifyListeners();
  }

  void updateUserProfile(UserProfile user) {
    _user = user;
    notifyListeners();
  }
}
