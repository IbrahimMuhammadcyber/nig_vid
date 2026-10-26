import 'package:flutter/material.dart';

import '../app_state.dart';
import 'create_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'projects_screen.dart';
import 'templates_screen.dart';

/// Main screen with the bottom navigation:
/// Home, Create, Projects, Templates, Profile.
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  void _go(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.of(context);
    final List<Widget> pages = <Widget>[
      HomeScreen(onNavigate: _go),
      const CreateScreen(),
      const ProjectsScreen(),
      const TemplatesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: s.t('nav.home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: const Icon(Icons.add_circle),
            label: s.t('nav.create'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.folder_outlined),
            selectedIcon: const Icon(Icons.folder),
            label: s.t('nav.projects'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: s.t('nav.templates'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: s.t('nav.profile'),
          ),
        ],
      ),
    );
  }
}
