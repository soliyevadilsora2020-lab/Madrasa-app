import 'package:flutter/material.dart';

import '../l10n.dart';

class SchedulePage extends StatefulWidget {
  final Map<String, dynamic> data;
  final Future<void> Function() onRefresh;

  const SchedulePage({super.key, required this.data, required this.onRefresh});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _group = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final groups = (widget.data['schedule'] as List?) ?? const [];

    if (groups.isEmpty) {
      return Center(child: Text(tr('no_lessons')));
    }
    if (_group >= groups.length) _group = 0;

    final group = groups[_group] as Map<String, dynamic>;
    final days = (group['days'] as List?) ?? const [];
    final weekday = DateTime.now().weekday;

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: groups.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final g = groups[i] as Map<String, dynamic>;
                return ChoiceChip(
                  label: Text(loc(g['group'])),
                  selected: i == _group,
                  onSelected: (_) => setState(() => _group = i),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          for (final d in days) _dayCard(context, d as Map<String, dynamic>, weekday, cs),
        ],
      ),
    );
  }

  Widget _dayCard(BuildContext context, Map<String, dynamic> day, int weekday,
      ColorScheme cs) {
    final isToday = day['weekday'] == weekday;
    final lessons = (day['lessons'] as List?) ?? const [];

    return Card(
      color: isToday ? cs.primaryContainer : null,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      loc(day['day']),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (isToday)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(tr('today'),
                          style: TextStyle(color: cs.onPrimary, fontSize: 12)),
                    ),
                ],
              ),
            ),
            if (lessons.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(tr('no_lessons')),
              ),
            for (final l in lessons)
              _lessonTile(context, l as Map<String, dynamic>, cs),
          ],
        ),
      ),
    );
  }

  Widget _lessonTile(BuildContext context, Map<String, dynamic> l, ColorScheme cs) {
    final teacher = loc(l['teacher']);
    final room = loc(l['room']);
    final sub = [teacher, room].where((s) => s.isNotEmpty).join(' • ');
    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 92,
        child: Text(
          (l['time'] ?? '').toString(),
          textDirection: TextDirection.ltr,
          style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600),
        ),
      ),
      title: Text(loc(l['subject'])),
      subtitle: sub.isEmpty ? null : Text(sub),
    );
  }
}
