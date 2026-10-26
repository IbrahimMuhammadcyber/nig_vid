import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../tools.dart';
import '../widgets.dart';

/// Creation workspace: prompt editor, model area, cost, safety, generate.
///
/// Honest by design: with no provider connected, Generate is disabled and the
/// screen says why. Nothing here pretends to produce a result.
class WorkspaceScreen extends StatefulWidget {
  final ToolInfo tool;
  final String initialPrompt;

  const WorkspaceScreen({
    super.key,
    required this.tool,
    this.initialPrompt = '',
  });

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPrompt);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _savePrompt(AppState s) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String text = _controller.text.trim();
    if (text.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(s.t('ws.emptyPrompt'))));
      return;
    }
    final bool ok = await s.addPrompt(text);
    messenger.showSnackBar(
      SnackBar(content: Text(s.t(ok ? 'ws.saved' : 'ws.saveFailed'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.of(context);
    final bool providerReady =
        widget.tool.task != null && s.providers.isAvailable(widget.tool.task!);
    final int length = _controller.text.length;

    return Scaffold(
      appBar: AppBar(title: Text(s.t(widget.tool.titleKey))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Text(
              s.t('ws.prompt'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: s.t('ws.hint')),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text(
                  s.tn('ws.chars', length),
                  style: const TextStyle(color: NvColors.textMuted),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: length == 0 ? null : _controller.clear,
                  icon: const Icon(Icons.close, size: 18),
                  label: Text(s.t('ws.clear')),
                ),
                TextButton.icon(
                  onPressed: () => _savePrompt(s),
                  icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                  label: Text(s.t('ws.save')),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              s.t('ws.translate.note'),
              style: const TextStyle(
                color: NvColors.textMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            SectionTitle(s.t('ws.model')),
            Panel(
              child: Text(
                providerReady ? '' : s.t('ws.model.none'),
                style: const TextStyle(color: NvColors.textMuted, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            Panel(
              child: Row(
                children: <Widget>[
                  Text(
                    s.t('ws.cost'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    s.t('ws.cost.unavailable'),
                    style: const TextStyle(color: NvColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Panel(
              borderColor: NvColors.warning.withAlpha(120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.shield_outlined,
                          color: NvColors.warning, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        s.t('ws.safety.title'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.t('ws.safety.body'),
                    style: const TextStyle(
                      color: NvColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Disabled until a provider integration and the job system exist.
            FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.auto_awesome),
              label: Text(s.t('ws.generate')),
            ),
            if (!providerReady) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                s.t('ws.generate.disabled'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: NvColors.textMuted, height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
