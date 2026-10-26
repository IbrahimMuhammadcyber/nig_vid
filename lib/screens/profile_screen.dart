import 'package:flutter/material.dart';

import '../app_state.dart';
import '../services/providers.dart';
import '../theme.dart';
import '../widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _info(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: const TextStyle(color: NvColors.textMuted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.of(context);
    final List<AiProvider> providers = s.providers.all;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: <Widget>[
        Text(
          s.t('profile.title'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        Text(
          s.t('profile.language'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(value: 'en', label: Text('English')),
              ButtonSegment<String>(value: 'ha', label: Text('Hausa')),
            ],
            selected: <String>{s.lang},
            onSelectionChanged: (Set<String> value) => s.setLang(value.first),
          ),
        ),
        const SizedBox(height: 20),
        _info(s.t('profile.account'), s.t('profile.account.body')),
        _info(s.t('profile.pricing'), s.t('profile.pricing.body')),
        _info(
          s.t('profile.providers'),
          providers.isEmpty
              ? s.t('profile.providers.none')
              : providers
                  .map((AiProvider p) => '${p.displayName} (${p.operatedBy})')
                  .join('\n'),
        ),
        _info(s.t('profile.about'), s.t('profile.about.body')),
        Center(
          child: Text(
            '${s.t('profile.version')} 0.1.0',
            style: const TextStyle(color: NvColors.textMuted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
