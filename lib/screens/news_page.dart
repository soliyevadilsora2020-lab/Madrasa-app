import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n.dart';

class NewsPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final Future<void> Function() onRefresh;

  const NewsPage({super.key, required this.data, required this.onRefresh});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String _filter = 'all'; // all | news | announcement

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final all = ((widget.data['news'] as List?) ?? const [])
        .map((e) => e as Map<String, dynamic>)
        .toList()
      ..sort((a, b) =>
          (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));
    final items = _filter == 'all'
        ? all
        : all.where((e) => (e['type'] ?? 'news') == _filter).toList();

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final f in const ['all', 'news', 'announcement'])
                ChoiceChip(
                  label: Text(tr(f == 'news' ? 'news' : f)),
                  selected: _filter == f,
                  onSelected: (_) => setState(() => _filter = f),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text(tr('no_news'))),
            ),
          for (final n in items) _newsCard(context, n, cs),
        ],
      ),
    );
  }

  Widget _newsCard(BuildContext context, Map<String, dynamic> n, ColorScheme cs) {
    final isAnn = n['type'] == 'announcement';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => NewsDetailPage(item: n)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(isAnn ? Icons.campaign : Icons.article_outlined,
                      size: 18, color: isAnn ? cs.error : cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    tr(isAnn ? 'announcement' : 'news_item'),
                    style: TextStyle(
                        color: isAnn ? cs.error : cs.primary,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(formatDate((n['date'] ?? '').toString()),
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 8),
              Text(loc(n['title']),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(loc(n['body']), maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const NewsDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(item['type'] == 'announcement' ? 'announcement' : 'news_item')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(formatDate((item['date'] ?? '').toString()),
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(loc(item['title']),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(loc(item['body']),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
