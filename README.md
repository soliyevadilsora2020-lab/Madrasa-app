# Madrasa mobil ilovasi

Flutter'da yozilgan ilova Android va iPhone uchun mo'ljallangan. U uch tilda ishlaydi: o'zbek, rus va arab (arab tilida ekran o'ngdan chapga aylanadi).

**Bo'limlar:** Bosh sahifa (madrasa haqida, aloqa), Dars jadvali (guruhlar bo'yicha, bugungi kun ajratib ko'rsatiladi), Yangiliklar va e'lonlar, Namoz vaqtlari (har kuni internetdan olinadi, keyingi namoz ko'rsatiladi), Sozlamalar (til tanlash).

---

## 1. APK faylni olish (kompyuterga hech narsa o'rnatmasdan)

1. https://github.com saytida ro'yxatdan o'ting.
2. **New repository** tugmasini bosing. Nom bering, masalan `madrasa-app`, va **Public**ni tanlang. Ma'lumotlar internetdan o'qilishi uchun repozitoriy ochiq bo'lishi kerak.
3. **uploading an existing file** havolasini bosing. Arxivdan chiqarilgan barcha fayl va papkalarni sudrab tashlang, so'ng **Commit changes** tugmasini bosing.
   - `.github` papkasi ko'rinmasa yoki yuklanmasa, uni alohida yarating. **Add file → Create new file** ni bosing, nomiga `.github/workflows/build.yml` deb yozing va `build.yml` faylining matnini ichiga joylang.
4. **Actions** bo'limiga o'ting. Yig'ish o'zi boshlanadi, taxminan 5–10 daqiqa davom etadi. Agar boshlanmasa, **APK yig'ish → Run workflow** ni bosing.
5. Yig'ish tugagach, repozitoriy sahifasining o'ng tomonidagi **Releases** bo'limida `madrasa.apk` fayli paydo bo'ladi. Uni telefonga yuklab olib o'rnating. Telefon "noma'lum manbalardan o'rnatish" uchun ruxsat so'rasa, ruxsat bering.

## 2. Ma'lumotlarni yangilash (ilovani qayta yig'ish shart emas)

Barcha matnlar `assets/data.json` faylida saqlanadi. GitHub'da shu faylni oching, ✏️ (Edit) belgisini bosing, kerakli joyni o'zgartiring va **Commit changes** tugmasini bosing. Foydalanuvchilarning ilovasi bir necha daqiqadan keyin yangi ma'lumotni o'zi yuklab oladi. Ekranni pastga tortib yangilash ham mumkin.

- `madrasa` — nomi, tavsifi, mudir, manzil, telefon, Telegram va boshqa ma'lumotlar. Har bir matn uch tilda yoziladi: `"uz"`, `"ru"`, `"ar"`.
- `schedule` — guruhlar va kunlar. `weekday`: 1 = dushanba, …, 7 = yakshanba.
- `news` — yangiliklar. `type`: `"news"` (yangilik) yoki `"announcement"` (e'lon). Sana `"2026-11-10"` ko'rinishida yoziladi.
- `prayer` — shahar (`city` inglizcha yoziladi, masalan `Bukhara`, `Tashkent`, `Samarkand`).

JSON faylda qo'shtirnoq, vergul va qavslar to'g'ri turishi muhim. Bitta vergul tushib qolsa, ilova yangi ma'lumotni o'qiy olmaydi va eski nusxasini ko'rsataveradi. Tekshirish uchun matnni https://jsonlint.com saytiga joylab ko'rish mumkin.

Ilova internet bo'lmaganda oxirgi yuklangan ma'lumotni ko'rsatadi.

## 3. Ilova nomi va belgisi

- Telefonda ko'rinadigan nom `.github/workflows/build.yml` faylidagi `APP_NAME: "Madrasa"` qatorida o'zgartiriladi.
- Belgi (ikonka) `assets/icon.png` faylidir. Uni 1024×1024 o'lchamdagi boshqa rasm bilan almashtirish mumkin.

Bu ikki faylni o'zgartirgandan keyin APK avtomatik qayta yig'iladi.

## 4. iPhone (iOS)

Kodning o'zi iPhone'da ham ishlaydi. Lekin iPhone'ga o'rnatish uchun Apple qoidalariga ko'ra quyidagilar zarur:
- **Apple Developer** hisobi (yiliga 99 $);
- Mac kompyuter, yoki Codemagic kabi bulutli xizmat.

Ilova `flutter build ipa` buyrug'i bilan yig'iladi va App Store yoki TestFlight orqali tarqatiladi.

## 5. O'z kompyuteringizda yig'ish (ixtiyoriy)

```
flutter create . --platforms=android,ios --org uz.madrasa --project-name madrasa_app
flutter pub get
dart run flutter_launcher_icons
flutter build apk --release --dart-define=DATA_URL=https://raw.githubusercontent.com/<login>/<repo>/main/assets/data.json
```

`android/app/src/main/AndroidManifest.xml` faylida `<application` qatoridan oldin quyidagi qator turishi kerak:
`<uses-permission android:name="android.permission.INTERNET"/>`
