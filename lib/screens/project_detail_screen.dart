import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Detail Proyek'),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(project.title, style: Theme.of(context).textTheme.headlineSmall),
        if (project.projectImageUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Image.network(
              project.projectImageUrl,
              height: 240,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text('Gambar gagal dimuat.'),
            ),
          ),
        const SizedBox(height: 16),
        Text(project.description),
        const SizedBox(height: 16),
        Text('Teknologi: ${project.techStack}'),
        if (project.projectUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SelectableText(project.projectUrl),
          ),
      ],
    ),
  );
}
