import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pengaturan & Dukungan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  tooltip: 'Tutup',
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _SectionTitle('Pengaturan'),
            const _SettingItem(label: 'Persempit rekomendasi Anda'),
            const _SettingItem(label: 'Tautan ke Pinterest'),
            const _SettingItem(label: 'Pusat laporan dan pelanggaran'),
            const _SettingItem(label: 'Instal aplikasi Windows'),
            const _SettingItem(
              label: 'Jadilah penguji beta',
              trailingIcon: Icons.open_in_new,
            ),
            const SizedBox(height: 12),
            const _SectionTitle('Dukungan'),
            const _SettingItem(
              label: 'Pusat bantuan',
              trailingIcon: Icons.open_in_new,
            ),
            const _SettingItem(
              label: 'Buat widget',
              trailingIcon: Icons.open_in_new,
            ),
            const _SettingItem(
              label: 'Penghapusan',
              trailingIcon: Icons.open_in_new,
            ),
            const _SettingItem(
              label: 'Iklan yang Dipersonalisasi',
              trailingIcon: Icons.open_in_new,
            ),
            const _SettingItem(label: 'Hak privasi Anda'),
            const _SettingItem(
              label: 'Kebijakan privasi',
              trailingIcon: Icons.open_in_new,
            ),
            const _SettingItem(
              label: 'Persyaratan Layanan',
              trailingIcon: Icons.open_in_new,
            ),
            const SizedBox(height: 12),
            const _SectionTitle('Referensi'),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: const [
                _ReferenceLink('Tentang'),
                _ReferenceLink('Pers'),
                _ReferenceLink('Bisnis'),
                _ReferenceLink('Karier'),
                _ReferenceLink('Pengembang'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black54,
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.label,
    this.trailingIcon,
  });

  final String label;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            if (trailingIcon != null)
              Icon(
                trailingIcon,
                size: 18,
                color: Colors.black87,
              ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceLink extends StatelessWidget {
  const _ReferenceLink(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A0DAB),
        ),
      ),
    );
  }
}
