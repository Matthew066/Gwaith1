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
  })
  onCreatePin;
  final void Function({required String name, required bool isPrivate})
  onCreateBoard;
  final void Function({required String title, required String theme})
  onCreateCollage;

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Future<void> _showCreatePinDialog(BuildContext context) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return _CreatePinDialog(
          boardNames: boardNames,
          onCreatePin: onCreatePin,
        );
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pin berhasil dibuat')));
    }
  }

  Future<void> _showCreateBoardDialog(BuildContext context) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return _CreateBoardDialog(onCreateBoard: onCreateBoard);
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Papan berhasil dibuat')));
    }
  }

  Future<void> _showCreateCollageDialog(BuildContext context) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return _CreateCollageDialog(onCreateCollage: onCreateCollage);
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kolase berhasil dibuat')));
    }
  }
}

class _CreatePinDialog extends StatefulWidget {
  const _CreatePinDialog({required this.boardNames, required this.onCreatePin});

  final List<String> boardNames;
  final void Function({
    required String title,
    required String author,
    required String description,
    required String imageUrl,
    String? boardName,
  })
  onCreatePin;

  @override
  State<_CreatePinDialog> createState() => _CreatePinDialogState();
}

class _CreatePinDialogState extends State<_CreatePinDialog> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController(text: 'Anda');
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  late String _selectedBoard;

  @override
  void initState() {
    super.initState();
    _selectedBoard = widget.boardNames.isNotEmpty
        ? widget.boardNames.first
        : '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buat Pin'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Pin'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Nama Pembuat'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 2,
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL Gambar (opsional)',
                hintText: 'https://...',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _selectedBoard,
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('Tanpa papan'),
                ),
                ...widget.boardNames.map(
                  (name) =>
                      DropdownMenuItem<String>(value: name, child: Text(name)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedBoard = value ?? '';
                });
              },
              decoration: const InputDecoration(labelText: 'Simpan ke papan'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            final title = _titleController.text.trim();
            if (title.isEmpty) {
              return;
            }

            final generatedImage =
                'https://picsum.photos/seed/pin_${DateTime.now().millisecondsSinceEpoch}/500/700';

            widget.onCreatePin(
              title: title,
              author: _authorController.text.trim().isEmpty
                  ? 'Anda'
                  : _authorController.text.trim(),
              description: _descriptionController.text.trim(),
              imageUrl: _imageUrlController.text.trim().isEmpty
                  ? generatedImage
                  : _imageUrlController.text.trim(),
              boardName: _selectedBoard.isEmpty ? null : _selectedBoard,
            );
            Navigator.pop(context, true);
          },
          child: const Text('Simpan Pin'),
        ),
      ],
    );
  }
}

class _CreateCollageDialog extends StatefulWidget {
  const _CreateCollageDialog({required this.onCreateCollage});

  final void Function({required String title, required String theme})
  onCreateCollage;

  @override
  State<_CreateCollageDialog> createState() => _CreateCollageDialogState();
}

class _CreateCollageDialogState extends State<_CreateCollageDialog> {
  final _titleController = TextEditingController();
  final _themeController = TextEditingController(text: 'Inspirasi');

  @override
  void dispose() {
    _titleController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buat Kolase'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Judul kolase'),
          ),
          TextField(
            controller: _themeController,
            decoration: const InputDecoration(labelText: 'Tema kolase'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            final title = _titleController.text.trim();
            if (title.isEmpty) {
              return;
            }

            widget.onCreateCollage(
              title: title,
              theme: _themeController.text.trim().isEmpty
                  ? 'Inspirasi'
                  : _themeController.text.trim(),
            );
            Navigator.pop(context, true);
          },
          child: const Text('Simpan Kolase'),
        ),
      ],
    );
  }
}

class _CreateBoardDialog extends StatefulWidget {
  const _CreateBoardDialog({required this.onCreateBoard});

  final void Function({required String name, required bool isPrivate})
  onCreateBoard;

  @override
  State<_CreateBoardDialog> createState() => _CreateBoardDialogState();
}

class _CreateBoardDialogState extends State<_CreateBoardDialog> {
  final _nameController = TextEditingController();
  var _isPrivate = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buat Papan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nama papan'),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _isPrivate,
            title: const Text('Papan privat'),
            onChanged: (value) => setState(() => _isPrivate = value),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) {
              return;
            }

            widget.onCreateBoard(name: name, isPrivate: _isPrivate);
            Navigator.pop(context, true);
          },
          child: const Text('Simpan Papan'),
        ),
      ],
    );
  }
}
