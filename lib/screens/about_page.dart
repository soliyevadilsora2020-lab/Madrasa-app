import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n.dart';

class AboutPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final Future<void> Function() onRefresh;

  const AboutPage({super.key, required this.data, required this.onRefresh});

  Future<void> _open(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final m = (data['madrasa'] as Map<String, dynamic>?) ?? {};

    final phone = (m['phone'] ?? '').toString();
    final email = (m['email'] ?? '').toString();
    final telegram = (m['telegram'] ?? '').toString();
    final website = (m['website'] ?? '').toString();

    final tiles = <Widget>[
      if (loc(m['director']).isNotEmpty)
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(tr('director')),
          subtitle: Text(loc(m['director'])),
        ),
      if (loc(m['founded']).isNotEmpty)
        ListTile(
          leading: const Icon(Icons.history_edu),
          title: Text(tr('founded')),
          subtitle: Text(loc(m['founded'])),
        ),
      if (loc(m['address']).isNotEmpty)
        ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: Text(tr('address')),
          subtitle: Text(loc(m['address'])),
          onTap: (m['map_url'] ?? '').toString().isEmpty
              ? null
              : () => _open(m['map_url'].toString()),
        ),
      if (phone.isNotEmpty)
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: Text(tr('phone')),
          subtitle: Text(phone, textDirection: TextDirection.ltr),
          onTap: () => _open('tel:${phone.replaceAll(' ', '')}'),
        ),
      if (email.isNotEmpty)
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: Text(tr('email')),
          subtitle: Text(email, textDirection: TextDirection.ltr),
          onTap: () => _open('mailto:$email'),
        ),
      if (telegram.isNotEmpty)
        ListTile(
          leading: const Icon(Icons.send_outlined),
          title: Text(tr('telegram')),
          subtitle: Text(telegram, textDirection: TextDirection.ltr),
          onTap: () => _open(telegram),
        ),
      if (website.isNotEmpty)
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(tr('website')),
          subtitle: Text(website, textDirection: TextDirection.ltr),
          onTap: () => _open(website),
        ),
    ];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [cs.primary, cs.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.mosque, size: 64, color: cs.onPrimary),
                const SizedBox(height: 12),
                Text(
                  loc(m['name']),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold),
                ),
                if (loc(m['slogan']).isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    loc(m['slogan']),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: cs.onPrimary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (loc(m['about']).isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('about'),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(loc(m['about']),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          if (tiles.isNotEmpty) ...[
            const SizedBox(height: 8),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(tr('contacts'),
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ...tiles,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
