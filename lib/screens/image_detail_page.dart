import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageDetailPage extends StatefulWidget {
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
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  late bool _isLiked;
  late int _likeCount;
  final List<String> _comments = [];

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = (widget.item['likeCount'] as int?) ?? 59;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    widget.onToggleLike?.call();
  }

  Future<void> _sharePin() async {
    final title = widget.item['title'] as String? ?? 'Pin Gwaith';
    final url = widget.item['url'] as String? ?? '';
    await Clipboard.setData(ClipboardData(text: '$title\n$url'));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link gambar disalin untuk dibagikan')),
    );
  }

  Future<void> _showCommentDialog() async {
    final controller = TextEditingController();

    try {
      final comment = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Tambah komentar'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                hintText: 'Tulis komentar Anda',
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
                child: const Text('Kirim'),
              ),
            ],
          );
        },
      );

      if (comment == null || comment.isEmpty) {
        return;
      }

      setState(() {
        _comments.insert(0, comment);
      });
    } finally {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['title'] as String? ?? 'Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(widget.item['url'] as String? ?? '', fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ActionButton(
                        icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                        label: '$_likeCount',
                        color: _isLiked ? Colors.red : Colors.black87,
                        onPressed: _toggleLike,
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        icon: Icons.mode_comment_outlined,
                        label: '${_comments.length}',
                        onPressed: _showCommentDialog,
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        icon: Icons.ios_share,
                        label: 'Share',
                        onPressed: _sharePin,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menu lainnya belum tersedia')),
                          );
                        },
                        icon: const Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.item['title'] as String? ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${widget.item['author'] as String? ?? '-'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (widget.item.containsKey('category'))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Kategori: ${widget.item['category']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(widget.item['description'] as String? ?? ''),
                  if (_comments.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Komentar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._comments.map(
                      (comment) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              child: Icon(Icons.person, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(comment)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = Colors.black87,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
