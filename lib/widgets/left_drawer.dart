import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final pageContext = Scaffold.of(context).context;
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => _replace(context, const MyHomePage()),
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('View Projects'),
            onTap: () => _replace(context, const ProjectListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () async {
              Navigator.pop(context);
              if (await ensureLoggedIn(pageContext) && pageContext.mounted) {
                Navigator.pushReplacement(
                  pageContext,
                  MaterialPageRoute<void>(
                    builder: (_) => const ProjectFormPage(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Add Education'),
            onTap: () => _replace(context, const EducationFormPage()),
          ),
          ListTile(
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Logout' : 'Login'),
            onTap: () async {
              Navigator.pop(context);
              if (isLoggedIn) {
                await logoutWithFeedback(pageContext);
              } else {
                await ensureLoggedIn(pageContext);
              }
            },
          ),
        ],
      ),
    );
  }

  void _replace(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.pushReplacement(MaterialPageRoute<void>(builder: (_) => page));
  }
}
