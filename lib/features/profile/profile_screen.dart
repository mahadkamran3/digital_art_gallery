import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/gallery_provider.dart';
// import '../../models/artwork.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gallery = Provider.of<GalleryProvider>(context);
    final user = gallery.user;
    final userArtworks =
        gallery.artworks.where((a) => a.artistName == user.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfileDialog(context, gallery),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage: user.avatarUrl.isNotEmpty
                  ? NetworkImage(user.avatarUrl)
                  : null,
              child: user.avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 48)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child:
                Text(user.name, style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 8),
          Center(
            child:
                Text(user.bio, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 24),
          Text('Your Artworks', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (userArtworks.isEmpty) const Text('No artworks uploaded yet.'),
          ...userArtworks.map((art) => Card(
                child: ListTile(
                  leading: art.imagePath.isNotEmpty
                      ? Image.network(art.imagePath,
                          width: 56, height: 56, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 40),
                  title: Text(art.title),
                  subtitle: Text(art.description),
                  trailing: Text(
                      '${art.createdAt.year}/${art.createdAt.month}/${art.createdAt.day}'),
                ),
              )),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, GalleryProvider gallery) {
    final user = gallery.user;
    final nameController = TextEditingController(text: user.name);
    final bioController = TextEditingController(text: user.bio);
    final avatarController = TextEditingController(text: user.avatarUrl);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              TextField(
                controller: avatarController,
                decoration:
                    const InputDecoration(labelText: 'Avatar Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              gallery.updateUserProfile(
                user.copyWith(
                  name: nameController.text,
                  bio: bioController.text,
                  avatarUrl: avatarController.text,
                ),
              );
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
