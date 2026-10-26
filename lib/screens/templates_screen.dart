import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/templates.dart';
import '../theme.dart';
import '../tools.dart';
import '../widgets.dart';
import 'workspace_screen.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String _query = '';

  bool _matches(AppState s, VideoTemplate tpl) {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final String haystack = <String>[
      tpl.title(s.lang),
      tpl.desc(s.lang),
      s.t('cat.${tpl.categoryKey}'),
      tpl.prompt,
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.of(context);
    final List<VideoTemplate> shown =
        kTemplates.where((VideoTemplate t) => _matches(s, t)).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: <Widget>[
        Text(
          s.t('templates.title'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (String value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: s.t('templates.search'),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 16),
        if (shown.isEmpty)
          Panel(
            child: Text(
              s.t('templates.none'),
              style: const TextStyle(color: NvColors.textMuted),
            ),
          ),
        for (final VideoTemplate tpl in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          s.t('cat.${tpl.categoryKey}'),
                          style: const TextStyle(
                            color: NvColors.cyan,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      StatusChip(
                        label: '${s.t('templates.aspect')}: ${tpl.aspect}',
                        color: NvColors.violet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tpl.title(s.lang),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tpl.desc(s.lang),
                    style: const TextStyle(
                      color: NvColors.textMuted,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    s.t('templates.example'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tpl.prompt,
                    style: const TextStyle(
                      color: NvColors.textMuted,
                      height: 1.4,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.shield_outlined,
                          size: 16, color: NvColors.warning),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          s.t(tpl.safetyKey),
                          style: const TextStyle(
                            color: NvColors.textMuted,
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext ctx) => WorkspaceScreen(
                            tool: toolById('t2v'),
                            initialPrompt: tpl.prompt,
                          ),
                        ),
                      );
                    },
                    child: Text(s.t('templates.use')),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
