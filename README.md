# Юрта-стек

Казуальная Flutter + Flame игра: складывай расписные юрты и строй башню от степи до космоса.

## Возможности

- Одно касание, точное попадание, комбо и восстановление ширины.
- Четыре мира с меняющимся фоном и плавным ускорением.
- Авторская эмблема юрты и геометрический орнамент в духе шырдака.
- Пять скинов, локальная статистика и настройки.
- Русский, английский и кыргызский интерфейсы.
- Автоматические Android APK и unsigned iOS IPA в GitHub Actions.

## Запуск локально

Установи Flutter SDK, затем выполни:

```sh
flutter create --platforms=android,ios --project-name=yurt_stack .
flutter pub get
flutter run
```

Проверки: `flutter analyze` и `flutter test`.

## Сборка и релиз

Workflow `.github/workflows/build.yml` проверяет код и собирает APK/IPA. Push тега `v*` запускает сборку и публикует GitHub Release с Android APK и unsigned iOS IPA. Для подписи iOS и публикации в App Store требуются сертификаты и учётная запись Apple Developer.
