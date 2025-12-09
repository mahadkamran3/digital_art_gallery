import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:io' show File;
import '../../models/artwork.dart';
import '../../widgets/artwork_interaction_bar.dart';
import '../../widgets/comment_dialog.dart';
import '../../widgets/gradient_text.dart';
import '../../providers/interactions_provider.dart';

class ArtworkDetailScreen extends StatelessWidget {
  final Artwork artwork;
  const ArtworkDetailScreen({super.key, required this.artwork});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: GradientText(text: artwork.title)),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/background02.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
          color: Colors.white.withOpacity(0.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: kIsWeb && artwork.imagePath.startsWith('http')
                        ? Image.network(
                            artwork.imagePath,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                        : !kIsWeb && artwork.imagePath.isNotEmpty
                        ? Image.file(
                            File(artwork.imagePath),
                            height: 300,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 300,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 80),
                          ),
                  ),

                  ArtworkInteractionBar(artwork: artwork),

                  const SizedBox(height: 16),
                  Text(
                    artwork.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${artwork.artistName}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${artwork.createdAt.year}/${artwork.createdAt.month}/${artwork.createdAt.day}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    artwork.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 24),

                  Consumer<InteractionsProvider>(
                    builder: (context, provider, child) {
                      final comments = provider.getCommentsForArtwork(
                        artwork.id,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comments (${comments.length})',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),

                          if (comments.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'No comments yet. Be the first to comment!',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ),
                            )
                          else
                            ...comments
                                .take(3)
                                .map(
                                  (comment) => Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          child: Text(
                                            comment.userName.isNotEmpty
                                                ? comment.userName[0]
                                                      .toUpperCase()
                                                : 'U',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    comment.userName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _formatDateTime(
                                                      comment.createdAt,
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                comment.text,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                          if (comments.length > 3)
                            TextButton(
                              onPressed: () => _showAllComments(context),
                              child: Text(
                                'View all ${comments.length} comments',
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showAllComments(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CommentDialog(artworkId: artwork.id),
    );
  }
}
