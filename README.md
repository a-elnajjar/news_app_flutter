# News App Flutter

A simple Flutter news reader that pulls top headlines from [NewsAPI.org](https://newsapi.org) and presents them with infinite scrolling, country filters, and basic search.

## Features
- Browse aggregated top headlines with lazy-loading pagination.
- Filter headlines by country using quick-access chips.
- Inline search bar for filtering the loaded articles by title or description.
- Article detail view with hero image and description text.
- Settings area with placeholder entries for future customization and an About screen that resolves the installed app version at runtime.

## Project structure
```
lib/
├── main.dart                 # App entry point and root scaffold/drawer
├── Models/Article.dart       # Article data model and JSON factory
├── services/news_service.dart# REST client for NewsAPI
├── screens/                  # UI screens (list, detail, settings, about)
└── widgets/article_tile.dart # List item used in the headlines list
```

## Requirements
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel stable, 3.0 or newer recommended)
- A NewsAPI.org API key

## Getting started
1. Install Flutter and set up a connected device or emulator.
2. Fetch project dependencies:
   ```bash
   flutter pub get
   ```
3. Add your NewsAPI key in `lib/services/news_service.dart` by setting the `_newsApiKey` field.
4. Run the application:
   ```bash
   flutter run
   ```

## Testing
No automated tests are currently included. You can add widget or unit tests under the `test/` directory and execute them with:
```bash
flutter test
```

## Configuration notes
- The default country filter is set to `us`; adjust `_selectedCountry` in `NewsListScreen` if you prefer a different default.
- Network errors are logged to the console; you may want to add user-facing error indicators for production builds.

## License
This project has no explicit license. Add one if you plan to distribute or open-source the application.
