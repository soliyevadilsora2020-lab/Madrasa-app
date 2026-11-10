import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Internetdagi data.json manzili. GitHub Actions uni avtomatik qo'yadi.
/// Qo'lda yig'ganda: flutter build apk --dart-define=DATA_URL=https://...
const String dataUrl = String.fromEnvironment('DATA_URL', defaultValue: '');

class DataRepo {
  static Map<String, dynamic>? _cache;

  /// Tartib: internet -> oxirgi saqlangan nusxa -> ilova ichidagi nusxa.
  static Future<Map<String, dynamic>> load({bool refresh = false}) async {
    if (_cache != null && !refresh) return _cache!;
    final prefs = await SharedPreferences.getInstance();

    if (dataUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(
            '$dataUrl?t=${DateTime.now().millisecondsSinceEpoch}');
        final r = await http.get(uri).timeout(const Duration(seconds: 10));
        if (r.statusCode == 200) {
          final body = utf8.decode(r.bodyBytes);
          final m = jsonDecode(body) as Map<String, dynamic>;
          await prefs.setString('data_cache', body);
          _cache = m;
          return m;
        }
      } catch (_) {
        // Internet yo'q yoki xato - saqlangan nusxadan foydalanamiz.
      }
    }

    final cached = prefs.getString('data_cache');
    if (cached != null) {
      try {
        final m = jsonDecode(cached) as Map<String, dynamic>;
        _cache = m;
        return m;
      } catch (_) {}
    }

    final asset = await rootBundle.loadString('assets/data.json');
    final m = jsonDecode(asset) as Map<String, dynamic>;
    _cache = m;
    return m;
  }
}

const List<String> prayerKeys = [
  'fajr',
  'sunrise',
  'dhuhr',
  'asr',
  'maghrib',
  'isha',
];

class PrayerService {
  /// aladhan.com dan kunlik namoz vaqtlarini oladi (kun davomida keshlanadi).
  static Future<Map<String, String>> fetch(Map<String, dynamic> cfg) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';
    final city = (cfg['city'] ?? 'Bukhara').toString();
    final country = (cfg['country'] ?? 'Uzbekistan').toString();
    final method = (cfg['method'] ?? 3).toString();
    final school = (cfg['school'] ?? 1).toString(); // 1 = Hanafiy (Asr)
    final cacheKey = 'prayer_${city}_${method}_$today';

    final cached = prefs.getString(cacheKey);
    if (cached != null) {
      return Map<String, String>.from(jsonDecode(cached) as Map);
    }

    final uri = Uri.https('api.aladhan.com', '/v1/timingsByCity', {
      'city': city,
      'country': country,
      'method': method,
      'school': school,
    });
    final r = await http.get(uri).timeout(const Duration(seconds: 10));
    if (r.statusCode != 200) {
      throw Exception('HTTP ${r.statusCode}');
    }
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    final tm = (j['data'] as Map<String, dynamic>)['timings']
        as Map<String, dynamic>;
    String c(String k) => tm[k].toString().split(' ').first;

    final res = <String, String>{
      'fajr': c('Fajr'),
      'sunrise': c('Sunrise'),
      'dhuhr': c('Dhuhr'),
      'asr': c('Asr'),
      'maghrib': c('Maghrib'),
      'isha': c('Isha'),
    };
    await prefs.setString(cacheKey, jsonEncode(res));
    return res;
  }

  /// Hozirgi vaqtdan keyingi namozni topadi.
  static String nextKey(Map<String, String> t) {
    final now = DateTime.now();
    final mins = now.hour * 60 + now.minute;
    for (final k in prayerKeys) {
      final v = t[k];
      if (v == null) continue;
      final parts = v.split(':');
      if (parts.length < 2) continue;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      if (h * 60 + m > mins) return k;
    }
    return 'fajr';
  }
}

/// "2026-11-10" -> "10.11.2026"
String formatDate(String s) {
  final p = s.split('-');
  if (p.length != 3) return s;
  return '${p[2]}.${p[1]}.${p[0]}';
}
