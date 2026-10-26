import 'package:flutter/material.dart';

import 'app_state.dart';
import 'screens/shell.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NigVidApp());
}

class NigVidApp extends StatefulWidget {
  const NigVidApp({super.key});

  @override
  State<NigVidApp> createState() => _NigVidAppState();
}

class _NigVidAppState extends State<NigVidApp> {
  final AppState _state = AppState();

  @override
  void initState() {
    super.initState();
    _state.load();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'NIG_VID',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const Shell(),
      ),
    );
  }
}
