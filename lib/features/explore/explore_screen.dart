import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _items = List.generate(
    20,
    (i) => {
      'id': '$i',
      'title': 'Artwork ${i + 1}',
      'image': 'assets/images/background02.jpg',
    },
  );
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredItems {
    if (_query.trim().isEmpty) return _items;
    final q = _query.toLowerCase();
    return _items
        .where((it) => it['title']!.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              if (_query.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  child: const Icon(Icons.clear, color: Colors.grey),
                ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.75,
          ),
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            final item = _filteredItems[index];
            return GestureDetector(
              onTap: () {
                // Placeholder: show enlarged image or navigate to detail
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item['image'] != null)
                          Image.asset(item['image']!, fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item['title'] ?? ''),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (item['image'] != null)
                      Image.asset(item['image']!, fit: BoxFit.cover)
                    else
                      Container(color: Colors.grey[300]),
                    Positioned(
                      left: 6,
                      bottom: 6,
                      right: 6,
                      child: Container(
                        color: Colors.black45,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ),
                        child: Text(
                          item['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
