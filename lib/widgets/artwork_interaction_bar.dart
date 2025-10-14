import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/interactions_provider.dart';
import '../models/artwork.dart';
import 'comment_dialog.dart';

class ArtworkInteractionBar extends StatelessWidget {
  final Artwork artwork;

  const ArtworkInteractionBar({super.key, required this.artwork});

  @override
  Widget build(BuildContext context) {
    return Consumer<InteractionsProvider>(
      builder: (context, interactionsProvider, child) {
        final isLiked = interactionsProvider.isArtworkLikedByCurrentUser(
          artwork.id,
        );
        final likesCount = interactionsProvider.getLikesCount(artwork.id);
        final commentsCount = interactionsProvider.getCommentsCount(artwork.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              // Like button
              InkWell(
                onTap: () => interactionsProvider.toggleLike(artwork.id),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey[600],
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        likesCount.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              InkWell(
                onTap: () => _showCommentDialog(context, artwork.id),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        commentsCount.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              InkWell(
                onTap: () => _shareArtwork(context, artwork),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.share_outlined,
                    color: Colors.grey[600],
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCommentDialog(BuildContext context, String artworkId) {
    showDialog(
      context: context,
      builder: (context) => CommentDialog(artworkId: artworkId),
    );
  }

  void _shareArtwork(BuildContext context, Artwork artwork) {
    final shareText =
        'Check out this amazing artwork!\n\n'
        '"${artwork.title}" by ${artwork.artistName}\n\n'
        '${artwork.description}\n\n'
        'Created: ${artwork.createdAt.year}/${artwork.createdAt.month}/${artwork.createdAt.day}\n\n'
        'Shared via Art Gallery App';

    Share.share(shareText, subject: 'Amazing Artwork: ${artwork.title}');
  }
}
