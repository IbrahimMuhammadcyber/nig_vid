import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../tools.dart';
import '../widgets.dart';

class HomeScreen extends StatelessWidget {
  /// Switches the bottom navigation tab (1 = Create, 3 = Templates).
  final void Function(int index) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.of(context);
    final int connected = s.providers.readyCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: <Widget>[
        const Align(alignment: Alignment.centerLeft, child: NvWordmark()),
        const SizedBox(height: 28),
        Text(
          s.t('app.tagline'),
          style: const TextStyle(
            fontSize: 34,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: NvColors.text,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          s.t('app.altTagline'),
          style: const TextStyle(fontSize: 16, color: NvColors.cyan),
        ),
        const SizedBox(height: 14),
        Text(
          s.t('home.intro'),
          style: const TextStyle(
            fontSize: 16,
            height: 1.45,
            color: NvColors.textMuted,
          ),
        ),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: () => onNavigate(1),
          icon: const Icon(Icons.movie_creation_outlined),
          label: Text(s.t('home.cta')),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => onNavigate(3),
          icon: const Icon(Icons.dashboard_outlined),
          label: Text(s.t('home.explore')),
        ),
        const SizedBox(height: 24),
        Panel(
          borderColor: connected == 0 ? NvColors.warning.withAlpha(120) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    connected == 0 ? Icons.info_outline : Icons.check_circle_outline,
                    color: connected == 0 ? NvColors.warning : NvColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s.t('home.status.title'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                connected == 0
                    ? s.t('home.status.noProvider')
                    : s.tn('home.status.connected', connected),
                style: const TextStyle(color: NvColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 8),
              Text(
                s.t('home.credits'),
                style: const TextStyle(color: NvColors.textMuted, height: 1.4),
              ),
            ],
          ),
        ),
        SectionTitle(s.t('home.features')),
        for (final ToolInfo tool in kTools)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Panel(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(tool.icon, color: NvColors.violet),
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
                ],
              ),
            ),
          ),
      ],
    );
  }
}
