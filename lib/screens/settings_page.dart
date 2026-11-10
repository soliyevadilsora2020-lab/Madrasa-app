import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n.dart';

class SettingsPage extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const SettingsPage({super.key, required this.onRefresh});

  static const _langs = [
    ['uz', "O'zbekcha"],
    ['ru', 'Русский'],
    ['ar', 'العربية'],
  ];

  Future<void> _setLang(String code) async {
    appLang.value = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', code);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(tr('language'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (final l in _langs)
                ListTile(
                  title: Text(l[1]),
                  trailing: appLang.value == l[0]
                      ? Icon(Icons.check_circle, color: cs.primary)
                      : const Icon(Icons.circle_outlined),
                  onTap: () => _setLang(l[0]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.refresh),
                title: Text(tr('refresh')),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await onRefresh();
                  messenger.showSnackBar(SnackBar(content: Text(tr('updated'))));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(tr('version')),
                trailing: const Text('1.0.0'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
