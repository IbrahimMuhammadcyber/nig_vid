import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../tools.dart';
import '../widgets.dart';
import 'editor_screen.dart';
import 'workspace_screen.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  void _openTool(BuildContext context, AppState s, ToolInfo tool) {
    if (tool.planned) {
      showDialog<void>(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: Text(s.t(tool.titleKey)),
          content: Text(s.t('create.planned.body')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(s.t('common.close')),
            ),
          ],
        ),
      );
      return;
    }
    if (tool.id == 'editor') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext ctx) => const EditorScreen(),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext ctx) => WorkspaceScreen(tool: tool),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: <Widget>[
        Text(
          s.t('create.title'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          s.t('create.pick'),
          style: const TextStyle(color: NvColors.textMuted, fontSize: 16),
        ),
        const SizedBox(height: 16),
        for (final ToolInfo tool in kTools)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openTool(context, s, tool),
              child: Panel(
                child: Row(
                  children: <Widget>[
                    Icon(tool.icon, color: NvColors.violet, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            s.t(tool.titleKey),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.t(tool.descKey),
                            style: const TextStyle(
                              color: NvColors.textMuted,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip(
                      label: tool.planned
                          ? s.t('common.planned')
                          : s.t('common.available'),
                      color: tool.planned ? NvColors.warning : NvColors.success,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
