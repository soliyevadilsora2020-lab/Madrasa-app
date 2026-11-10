import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n.dart';

class PrayerPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const PrayerPage({super.key, required this.data});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  late Future<Map<String, String>> _future;

  Map<String, dynamic> get _cfg =>
      (widget.data['prayer'] as Map<String, dynamic>?) ?? <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _future = PrayerService.fetch(_cfg);
  }

  void _retry() {
    setState(() => _future = PrayerService.fetch(_cfg));
  }

  static const _icons = {
    'fajr': Icons.nights_stay_outlined,
    'sunrise': Icons.wb_twilight,
    'dhuhr': Icons.wb_sunny_outlined,
    'asr': Icons.light_mode_outlined,
    'maghrib': Icons.brightness_6_outlined,
    'isha': Icons.dark_mode_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';

    return FutureBuilder<Map<String, String>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || snap.data == null || snap.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off, size: 48, color: cs.outline),
                  const SizedBox(height: 12),
                  Text(tr('error_prayer'), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _retry, child: Text(tr('retry'))),
                ],
              ),
            ),
          );
        }

        final t = snap.data!;
        final next = PrayerService.nextKey(t);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(tr('prayer_times'),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: cs.onPrimary)),
                  const SizedBox(height: 4),
                  Text('${loc(_cfg['city_name']).isNotEmpty ? loc(_cfg['city_name']) : (_cfg['city'] ?? '')} • $dateStr',
                      style: TextStyle(color: cs.onPrimary)),
                  const SizedBox(height: 16),
                  Text(tr('next'), style: TextStyle(color: cs.onPrimary)),
                  Text(
                    '${tr(next)}  ${t[next] ?? ''}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: cs.onPrimary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (final k in prayerKeys)
              Card(
                color: k == next ? cs.primaryContainer : null,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(_icons[k], color: cs.primary),
                  title: Text(tr(k),
                      style: TextStyle(
                          fontWeight:
                              k == next ? FontWeight.bold : FontWeight.normal)),
                  trailing: Text(
                    t[k] ?? '--:--',
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
