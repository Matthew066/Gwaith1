import 'package:flutter/material.dart';

import '../screens/image_detail_page.dart';

class PinterestMasonryGrid extends StatelessWidget {
  const PinterestMasonryGrid({
    super.key,
    required this.items,
    this.likedPinIds = const <int>{},
    this.onToggleLike,
    this.friendNames = const <String>[],
    this.boardNames = const <String>[],
    this.onSendPinToDm,
    this.onSavePinToBoard,
  });

  final List<Map<String, dynamic>> items;
  final Set<int> likedPinIds;
  final ValueChanged<int>? onToggleLike;
  final List<String> friendNames;
  final List<String> boardNames;
  final void Function(String friendName, Map<String, dynamic> pin)?
  onSendPinToDm;
  final String Function(Map<String, dynamic> pin, String boardName)?
  onSavePinToBoard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: items
                    .asMap()
                    .entries
                    .where((entry) => entry.key.isEven)
                    .map((entry) => _buildGridItem(context, entry.value))
                    .toList(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: items
                    .asMap()
                    .entries
                    .where((entry) => entry.key.isOdd)
                    .map((entry) => _buildGridItem(context, entry.value))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    final pinId = item['id'] as int?;
    final isLiked = pinId != null && likedPinIds.contains(pinId);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImageDetailPage(
              item: item,
              isLiked: isLiked,
              friendNames: friendNames,
              boardNames: boardNames,
              onSendPinToDm: onSendPinToDm,
              onToggleLike: pinId != null && onToggleLike != null
                  ? () => onToggleLike!(pinId)
                  : null,
              onSavePinToBoard: onSavePinToBoard,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                item['url'],
                height: item['height'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              if (pinId != null && onToggleLike != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => onToggleLike!(pinId),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.black87,
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['author'] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
