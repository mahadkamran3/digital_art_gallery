import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../providers/gallery_provider.dart';
import '../../providers/interactions_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Map<String, int> _postsLast7Days(List artworks) {
    final now = DateTime.now();
    final result = <String, int>{};

    for (var i = 6; i >= 0; i--) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));

      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      result[key] = 0;
    }

    for (var a in artworks) {
      final d = DateTime(a.createdAt.year, a.createdAt.month, a.createdAt.day);
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

      if (result.containsKey(key)) result[key] = result[key]! + 1;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final gallery = Provider.of<GalleryProvider>(context);
    final user = gallery.user;

    final interactions = Provider.of<InteractionsProvider>(context);

    final userArtworks = gallery.artworks
        .where((a) => a.artistName == user.name)
        .toList();

    final postsByDay = _postsLast7Days(userArtworks);

    // Use interactions provider so analytics reflect likes/comments immediately
    final totalLikes = userArtworks.fold<int>(
      0,
      (t, a) => t + interactions.getLikesForArtwork(a.id).length,
    );
    final totalComments = userArtworks.fold<int>(
      0,
      (t, a) => t + interactions.getCommentsForArtwork(a.id).length,
    );

    final avgLikes = userArtworks.isNotEmpty
        ? totalLikes / userArtworks.length
        : 0.0;

    final topPosts = List.from(userArtworks)
      ..sort(
        (a, b) => interactions
            .getLikesForArtwork(b.id)
            .length
            .compareTo(interactions.getLikesForArtwork(a.id).length),
      );
    final top3 = topPosts.take(3).toList();

    final labels = postsByDay.keys.toList();
    final counts = postsByDay.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              'Hello, ${user.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // 🔵 Posting Frequency (Bar Chart)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posting Frequency (last 7 days)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    SizedBox(
                      height: 220,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: [
                          ColumnSeries<_BarData, String>(
                            dataSource: List.generate(
                              labels.length,
                              (i) => _BarData(labels[i], counts[i]),
                            ),
                            xValueMapper: (d, _) => d.label,
                            yValueMapper: (d, _) => d.value,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🟠 Engagement Breakdown (Pie Chart)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Engagement Breakdown',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    SizedBox(
                      height: 200,
                      child: SfCircularChart(
                        legend: Legend(isVisible: true),
                        series: [
                          PieSeries<_PieData, String>(
                            dataSource: [
                              _PieData('Likes', totalLikes.toDouble()),
                              _PieData('Comments', totalComments.toDouble()),
                            ],
                            xValueMapper: (d, _) => d.label,
                            yValueMapper: (d, _) => d.value,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      'Total posts: ${userArtworks.length} • Likes: $totalLikes • Comments: $totalComments',
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Avg likes / post'),
                              Text(
                                avgLikes.toStringAsFixed(1),
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total posts'),
                              Text(
                                '${userArtworks.length}',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔵 Activity Trend (Line Chart)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity Trend',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    SizedBox(
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: [
                          LineSeries<_BarData, String>(
                            dataSource: List.generate(
                              labels.length,
                              (i) => _BarData(labels[i], counts[i]),
                            ),
                            xValueMapper: (d, _) => d.label,
                            yValueMapper: (d, _) => d.value,
                            color: Colors.blueAccent,
                            width: 3,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ⭐ Top 3 Posts
            if (top3.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top posts',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),

                      Column(
                        children: top3.map((a) {
                          return ListTile(
                            leading: a.imagePath.isNotEmpty
                                ? Image.network(
                                    a.imagePath,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image),
                            title: Text(a.title),
                            subtitle: Text(
                              '${interactions.getLikesForArtwork(a.id).length} likes • ${interactions.getCommentsForArtwork(a.id).length} comments',
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BarData {
  final String label;
  final int value;
  _BarData(this.label, this.value);
}

class _PieData {
  final String label;
  final double value;
  _PieData(this.label, this.value);
}
