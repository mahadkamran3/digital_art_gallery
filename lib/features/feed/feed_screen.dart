import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show File;
import '../../providers/gallery_provider.dart';
import '../../widgets/artwork_interaction_bar.dart';
import '../../widgets/gradient_text.dart';
import 'artwork_detail_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final artworks = context.watch<GalleryProvider>().artworks;
    final filtered = _search.isEmpty
        ? artworks
        : artworks
              .where(
                (a) =>
                    a.title.toLowerCase().contains(_search.toLowerCase()) ||
                    a.artistName.toLowerCase().contains(_search.toLowerCase()),
              )
              .toList();
    return Scaffold(
      appBar: AppBar(
        title: const GradientText(text: 'Art Work'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by title or artist...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/background02.jpg'),
            fit: BoxFit.cover,
            // dim the background image so it doesn't overpower the UI
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
          // an optional subtle overlay color (keeps content readable)
          color: Colors.white.withOpacity(0.0),
        ),
        child: filtered.isEmpty
            ? Center(
                child: Text(
                  'No artworks found.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final art = filtered[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                child: Text(
                                  art.artistName.isNotEmpty
                                      ? art.artistName[0].toUpperCase()
                                      : 'A',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      art.artistName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      '${art.createdAt.year}/${art.createdAt.month}/${art.createdAt.day}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ArtworkDetailScreen(artwork: art),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: _buildArtworkImage(art.imagePath),
                          ),
                        ),

                        ArtworkInteractionBar(artwork: art),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                art.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              if (art.description.isNotEmpty)
                                Text(
                                  art.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildArtworkImage(String path) {
    if (kIsWeb || path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 48),
        ),
      );
    } else if (path.isNotEmpty) {
      try {
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 48),
          ),
        );
      } catch (_) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 48),
        );
      }
    } else {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 48),
      );
    }
  }
}
