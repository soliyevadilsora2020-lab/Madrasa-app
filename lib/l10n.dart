import 'package:flutter/foundation.dart';

/// Joriy til: 'uz', 'ru' yoki 'ar'.
final ValueNotifier<String> appLang = ValueNotifier<String>('uz');

const Map<String, Map<String, String>> _strings = {
  "home": {"uz": "Bosh sahifa", "ru": "Главная", "ar": "الرئيسية"},
  "schedule": {"uz": "Dars jadvali", "ru": "Расписание", "ar": "الجدول"},
  "news": {"uz": "Yangiliklar", "ru": "Новости", "ar": "الأخبار"},
  "prayer": {"uz": "Namoz", "ru": "Намаз", "ar": "الصلاة"},
  "prayer_times": {"uz": "Namoz vaqtlari", "ru": "Время намаза", "ar": "مواقيت الصلاة"},
  "settings": {"uz": "Sozlamalar", "ru": "Настройки", "ar": "الإعدادات"},
  "about": {"uz": "Madrasa haqida", "ru": "О медресе", "ar": "عن المدرسة"},
  "contacts": {"uz": "Ma'lumotlar va aloqa", "ru": "Информация и контакты", "ar": "معلومات والتواصل"},
  "director": {"uz": "Mudir", "ru": "Директор", "ar": "المدير"},
  "founded": {"uz": "Tashkil topgan", "ru": "Основано", "ar": "تأسست"},
  "address": {"uz": "Manzil", "ru": "Адрес", "ar": "العنوان"},
  "phone": {"uz": "Telefon", "ru": "Телефон", "ar": "الهاتف"},
  "email": {"uz": "Elektron pochta", "ru": "Эл. почта", "ar": "البريد الإلكتروني"},
  "telegram": {"uz": "Telegram", "ru": "Telegram", "ar": "تيليجرام"},
  "website": {"uz": "Veb-sayt", "ru": "Сайт", "ar": "الموقع"},
  "today": {"uz": "Bugun", "ru": "Сегодня", "ar": "اليوم"},
  "no_lessons": {"uz": "Dars yo'q", "ru": "Нет занятий", "ar": "لا توجد دروس"},
  "no_news": {"uz": "Hozircha yangilik yo'q", "ru": "Пока нет новостей", "ar": "لا توجد أخبار حاليا"},
  "all": {"uz": "Barchasi", "ru": "Все", "ar": "الكل"},
  "announcement": {"uz": "E'lon", "ru": "Объявление", "ar": "إعلان"},
  "news_item": {"uz": "Yangilik", "ru": "Новость", "ar": "خبر"},
  "fajr": {"uz": "Bomdod", "ru": "Фаджр", "ar": "الفجر"},
  "sunrise": {"uz": "Quyosh chiqishi", "ru": "Восход", "ar": "الشروق"},
  "dhuhr": {"uz": "Peshin", "ru": "Зухр", "ar": "الظهر"},
  "asr": {"uz": "Asr", "ru": "Аср", "ar": "العصر"},
  "maghrib": {"uz": "Shom", "ru": "Магриб", "ar": "المغرب"},
  "isha": {"uz": "Xufton", "ru": "Иша", "ar": "العشاء"},
  "next": {"uz": "Keyingi namoz", "ru": "Следующий намаз", "ar": "الصلاة القادمة"},
  "language": {"uz": "Til", "ru": "Язык", "ar": "اللغة"},
  "retry": {"uz": "Qayta urinish", "ru": "Повторить", "ar": "إعادة المحاولة"},
  "error_prayer": {
    "uz": "Namoz vaqtlarini yuklab bo'lmadi. Internetni tekshiring.",
    "ru": "Не удалось загрузить время намаза. Проверьте интернет.",
    "ar": "تعذر تحميل مواقيت الصلاة. تحقق من الاتصال بالإنترنت."
  },
  "city": {"uz": "Shahar", "ru": "Город", "ar": "المدينة"},
  "refresh": {"uz": "Ma'lumotlarni yangilash", "ru": "Обновить данные", "ar": "تحديث البيانات"},
  "updated": {"uz": "Ma'lumotlar yangilandi", "ru": "Данные обновлены", "ar": "تم تحديث البيانات"},
  "version": {"uz": "Ilova versiyasi", "ru": "Версия приложения", "ar": "إصدار التطبيق"},
};

/// Interfeys matnini joriy tilda qaytaradi.
String tr(String key) =>
    _strings[key]?[appLang.value] ?? _strings[key]?["uz"] ?? key;

/// data.json ichidagi {"uz": .., "ru": .., "ar": ..} maydonini joriy tilda qaytaradi.
String loc(dynamic v) {
  if (v == null) return "";
  if (v is Map) {
    final val = v[appLang.value] ?? v["uz"];
    if (val != null && val.toString().isNotEmpty) return val.toString();
    for (final x in v.values) {
      if (x != null && x.toString().isNotEmpty) return x.toString();
    }
    return "";
  }
  return v.toString();
}
