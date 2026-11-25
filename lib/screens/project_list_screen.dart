import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<Project>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = context.read<ApiClient>().getProjects();
  }

  Future<void> _reload() async {
    final request = context.read<ApiClient>().getProjects();
    setState(() => _projects = request);
    try {
      await request;
    } catch (_) {
      // FutureBuilder displays the failure.
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Daftar Proyek'),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    drawer: const LeftDrawer(),
    body: FutureBuilder<List<Project>>(
      future: _projects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Daftar proyek gagal dimuat.'),
                TextButton(onPressed: _reload, child: const Text('Coba lagi')),
              ],
            ),
          );
        }

        final projects = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _reload,
          child: projects.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(child: Text('Belum ada proyek.')),
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return Card(
                      child: ListTile(
                        title: Text(project.title),
                        subtitle: Text(
                          '${project.techStack}\n${project.description}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => ProjectDetailScreen(project: project),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    ),
  );
}
