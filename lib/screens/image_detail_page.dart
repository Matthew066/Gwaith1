import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    super.key,
    required this.item,
    this.isLiked = false,
    this.onToggleLike,
  });

  final Map<String, dynamic> item;
  final bool isLiked;
  final VoidCallback? onToggleLike;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title'] ?? 'Detail'),
        actions: [
          if (onToggleLike != null)
            IconButton(
              onPressed: onToggleLike,
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : null,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(item['url'], fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${item['author'] ?? '-'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (item.containsKey('category'))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Kategori: ${item['category']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(item['description'] ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
