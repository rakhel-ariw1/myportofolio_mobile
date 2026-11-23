import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String npm = '2506605462';
  final String nama = 'Rakhel Aqeela Hapsari Ariwibowo';
  final String kelas = 'PBP B';

  static const List<ItemHomepage> items = [
    ItemHomepage('Lihat Proyek', Icons.folder, Color(0xFF1565C0)),
    ItemHomepage('Tambah Proyek', Icons.add_circle, Color(0xFF2E7D32)),
    ItemHomepage('Tambah Edukasi', Icons.school, Color(0xFF6A1B9A)),
    ItemHomepage('Logout', Icons.logout, Color(0xFFC62828)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Susun kartu ke bawah pada layar sempit agar nama tetap terbaca.
              final bool compact = constraints.maxWidth < 600;
              final double cardWidth = compact
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 24) / 3;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: InfoCard(title: 'NPM', content: npm),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: InfoCard(title: 'Name', content: nama),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: InfoCard(title: 'Class', content: kelas),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Selamat datang di MyPortfolio Mobile!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: items
                        .map(
                          (item) =>
                              SizedBox(width: cardWidth, child: ItemCard(item)),
                        )
                        .toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Kartu identitas yang dapat dipakai ulang untuk setiap atribut profil.
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
