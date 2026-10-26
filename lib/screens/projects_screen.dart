import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../tools.dart';
import '../widgets.dart';
import 'workspace_screen.dart';

/// Shows local drafts (saved prompts). Cloud projects need an account,
/// which does not exist yet, and the screen says so.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: <Widget>[
        Text(
          s.t('projects.title'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Panel(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.cloud_off_outlined,
                  color: NvColors.textMuted, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s.t('projects.cloud'),
                  style: const TextStyle(color: NvColors.textMuted, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        SectionTitle(s.t('projects.local')),
        if (s.savedPrompts.isEmpty)
          Panel(
            child: Text(
              s.t('projects.empty'),
              style: const TextStyle(color: NvColors.textMuted, height: 1.4),
            ),
          )
        else
          for (int i = 0; i < s.savedPrompts.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      s.savedPrompts[i],
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => s.removePrompt(i),
                          child: Text(s.t('common.delete')),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext ctx) => WorkspaceScreen(
                                  tool: toolById('t2v'),
                                  initialPrompt: s.savedPrompts[i],
                                ),
                              ),
                            );
                          },
                          child: Text(s.t('common.use')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
