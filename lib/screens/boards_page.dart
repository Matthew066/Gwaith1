import 'package:flutter/material.dart';

import 'board_detail_page.dart';

class BoardsPage extends StatelessWidget {
  const BoardsPage({
    super.key,
    required this.boards,
    required this.boardNames,
    required this.onAddBoard,
    required this.onSavePinToBoard,
  });

  final List<Map<String, dynamic>> boards;
  final List<String> boardNames;
  final void Function({required String name, required bool isPrivate})
  onAddBoard;
  final String Function(Map<String, dynamic> pin, String boardName)
  onSavePinToBoard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Papan Anda (Boards)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: boards.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () => _showCreateBoardDialog(context),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          'Buat',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final board = boards[index - 1];
                final pins = (board['pins'] as List)
                    .cast<Map<String, dynamic>>();
                return _buildBoardCard(board, pins, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardCard(
    Map<String, dynamic> board,
    List<Map<String, dynamic>> pins,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BoardDetailPage(
              name: board['name'] as String,
              pins: pins,
              boardNames: boardNames,
              onSavePinToBoard: onSavePinToBoard,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildPreviewImage(
                      pins.isNotEmpty ? pins[0]['url'] as String : null,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildPreviewImage(
                            pins.length > 1 ? pins[1]['url'] as String : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: _buildPreviewImage(
                            pins.length > 2 ? pins[2]['url'] as String : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(board['name'] as String),
              subtitle: Text('${board['pinCount']} Pin'),
              trailing: Icon(
                (board['isPrivate'] as bool)
                    ? Icons.lock_outline
                    : Icons.public,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(color: Colors.grey[300]);
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) =>
          Container(color: Colors.grey[300]),
    );
  }

  Future<void> _showCreateBoardDialog(BuildContext context) async {
    final nameController = TextEditingController();
    var isPrivate = true;

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Buat Papan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama Papan'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Privat'),
                      Switch(
                        value: isPrivate,
                        onChanged: (value) =>
                            setDialogState(() => isPrivate = value),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      onAddBoard(name: name, isPrivate: isPrivate);
                    }
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Papan dibuat')));
    }
  }
}
