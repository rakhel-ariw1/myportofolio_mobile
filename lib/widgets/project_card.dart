import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';

/// Warna disimpan bersama data menu agar ItemCard tidak perlu percabangan.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  const ItemHomepage(this.name, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          switch (item.name) {
            case 'Login':
              await ensureLoggedIn(context);
            case 'Logout':
              await logoutWithFeedback(Scaffold.of(context).context);
            case 'Tambah Proyek':
              if (await ensureLoggedIn(context) && context.mounted) {
                _open(context, const ProjectFormPage());
              }
            case 'Tambah Edukasi':
              _open(context, const EducationFormPage());
            case 'Lihat Proyek':
              _open(context, const ProjectListScreen());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }
}
