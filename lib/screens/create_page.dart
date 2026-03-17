import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({
    super.key,
    required this.boardNames,
    required this.onCreatePin,
    required this.onCreateBoard,
    required this.onCreateCollage,
  });

  final List<String> boardNames;
  final void Function({
    required String title,
    required String author,
    required String description,
    required String imageUrl,
    String? boardName,
  }) onCreatePin;
  final void Function({
    required String name,
    required bool isPrivate,
  }) onCreateBoard;
  final void Function({
    required String title,
    required String theme,
  }) onCreateCollage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_circle_outline, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'Buat Sesuatu yang Baru',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _createOption(
            context: context,
            icon: Icons.pin_drop,
            label: 'Buat Pin',
            onPressed: () => _showCreatePinDialog(context),
          ),
          _createOption(
            context: context,
            icon: Icons.dashboard_customize,
            label: 'Buat Papan',
            onPressed: () => _showCreateBoardDialog(context),
          ),
          _createOption(
            context: context,
            icon: Icons.auto_awesome_motion,
            label: 'Buat Kolase',
            onPressed: () => _showCreateCollageDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _createOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Future<void> _showCreatePinDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final authorController = TextEditingController(text: 'Anda');
    final descriptionController = TextEditingController();
    final imageUrlController = TextEditingController();
    var selectedBoard = boardNames.isNotEmpty ? boardNames.first : '';

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Buat Pin'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Judul Pin'),
                    ),
                    TextField(
                      controller: authorController,
                      decoration: const InputDecoration(labelText: 'Nama Pembuat'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL Gambar (opsional)',
                        hintText: 'https://...',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: selectedBoard,
                      items: [
                        const DropdownMenuItem<String>(
                          value: '',
                          child: Text('Tanpa papan'),
                        ),
                        ...boardNames.map(
                          (name) => DropdownMenuItem<String>(
                            value: name,
                            child: Text(name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedBoard = value ?? '';
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Simpan ke papan'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) {
                      return;
                    }

                    final generatedImage =
                        'https://picsum.photos/seed/pin_${DateTime.now().millisecondsSinceEpoch}/500/700';

                    onCreatePin(
                      title: title,
                      author: authorController.text.trim().isEmpty
                          ? 'Anda'
                          : authorController.text.trim(),
                      description: descriptionController.text.trim(),
                      imageUrl: imageUrlController.text.trim().isEmpty
                          ? generatedImage
                          : imageUrlController.text.trim(),
                      boardName: selectedBoard.isEmpty ? null : selectedBoard,
                    );
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Simpan Pin'),
                ),
              ],
            );
          },
        );
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pin berhasil dibuat')),
      );
    }
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
                    decoration: const InputDecoration(labelText: 'Nama papan'),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: isPrivate,
                    title: const Text('Papan privat'),
                    onChanged: (value) => setDialogState(() => isPrivate = value),
                    contentPadding: EdgeInsets.zero,
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
                    if (name.isEmpty) {
                      return;
                    }

                    onCreateBoard(name: name, isPrivate: isPrivate);
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Simpan Papan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Papan berhasil dibuat')),
      );
    }
  }

  Future<void> _showCreateCollageDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final themeController = TextEditingController(text: 'Inspirasi');

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Buat Kolase'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul kolase'),
              ),
              TextField(
                controller: themeController,
                decoration: const InputDecoration(labelText: 'Tema kolase'),
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
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  return;
                }

                onCreateCollage(
                  title: title,
                  theme: themeController.text.trim().isEmpty
                      ? 'Inspirasi'
                      : themeController.text.trim(),
                );
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Simpan Kolase'),
            ),
          ],
        );
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kolase berhasil dibuat')),
      );
    }
  }
}
