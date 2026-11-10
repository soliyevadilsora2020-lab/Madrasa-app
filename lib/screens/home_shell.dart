import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n.dart';
import 'about_page.dart';
import 'news_page.dart';
import 'prayer_page.dart';
import 'schedule_page.dart';
import 'settings_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    final d = await DataRepo.load(refresh: refresh);
    if (!mounted) return;
    setState(() => _data = d);
  }

  Future<void> _refresh() => _load(refresh: true);

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final madrasa = (data['madrasa'] as Map<String, dynamic>?) ?? {};
    final pages = <Widget>[
      AboutPage(data: data, onRefresh: _refresh),
      SchedulePage(data: data, onRefresh: _refresh),
      NewsPage(data: data, onRefresh: _refresh),
      PrayerPage(data: data),
      SettingsPage(onRefresh: _refresh),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc(madrasa['name'])),
        centerTitle: true,
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: tr('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: tr('schedule'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.campaign_outlined),
            selectedIcon: const Icon(Icons.campaign),
            label: tr('news'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.access_time),
            selectedIcon: const Icon(Icons.access_time_filled),
            label: tr('prayer'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: tr('settings'),
          ),
        ],
      ),
    );
  }
}
