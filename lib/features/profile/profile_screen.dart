import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/gallery_provider.dart';
import '../../providers/interactions_provider.dart';
import '../../widgets/gradient_text.dart';
import 'analytics_screen.dart';
// import '../../models/artwork.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gallery = Provider.of<GalleryProvider>(context);
    final user = gallery.user;
    final userArtworks = gallery.artworks
        .where((a) => a.artistName == user.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const GradientText(text: 'Profile'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.orange, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            ),
            color: Colors.black.withOpacity(0.0),
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black45,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.palette,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
            ),
            onPressed: () => _showEditProfileDialog(context, gallery),
            tooltip: 'Edit Profile',
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
            ),
            onPressed: () {
              // Placeholder for settings action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/background02.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
          color: Colors.white.withOpacity(0.0),
        ),
        child: ListView(
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
              child: Text(
                user.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                user.bio,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            // Analytics entry
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Analytics'),
              subtitle: const Text('View posting and engagement metrics'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Your Artworks',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (userArtworks.isEmpty) const Text('No artworks uploaded yet.'),
            ...userArtworks.map(
              (art) => Card(
                child: ListTile(
                  leading: art.imagePath.isNotEmpty
                      ? Image.network(
                          art.imagePath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 40),
                  title: Text(art.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(art.description),
                      const SizedBox(height: 6),
                      Text(
                        '${art.createdAt.year}/${art.createdAt.month}/${art.createdAt.day}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                        onPressed: () =>
                            _showEditArtworkDialog(context, gallery, art),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                        onPressed: () =>
                            _confirmDeleteArtwork(context, gallery, art),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
                decoration: const InputDecoration(
                  labelText: 'Avatar Image URL',
                ),
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
              context.read<InteractionsProvider>().setCurrentUserName(
                nameController.text,
              );
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditArtworkDialog(
    BuildContext context,
    GalleryProvider gallery,
    art,
  ) {
    final titleController = TextEditingController(text: art.title);
    final descController = TextEditingController(text: art.description);
    final imageController = TextEditingController(text: art.imagePath);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Artwork'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
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
              final updated = art.copyWith(
                title: titleController.text,
                description: descController.text,
                imagePath: imageController.text,
              );
              gallery.updateArtwork(updated);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Artwork updated')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteArtwork(
    BuildContext context,
    GalleryProvider gallery,
    art,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Artwork'),
        content: const Text('Are you sure you want to delete this artwork?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              gallery.removeArtwork(art.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Artwork deleted')));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
