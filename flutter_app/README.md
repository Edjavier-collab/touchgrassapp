# TouchGrass Flutter Web App

This is the Flutter Web implementation of the TouchGrass application, designed to help individuals with substance-use disorder manage cravings using the WOOP technique and 24-hour streak tracking.

## 🏗️ Architecture Overview

- **Frontend**: Flutter Web (Dart 3.x)
- **State Management**: Riverpod 2.x
- **Backend**: Supabase (Postgres + Edge Functions)
- **Storage**: Shared Preferences + Hive for offline support
- **Authentication**: Anonymous device-bound JWT

## 🚀 Quick Start

### Prerequisites

1. Flutter SDK 3.x installed
2. Supabase project configured
3. Web browser (Chrome recommended)

### Configuration

1. **Update Supabase Configuration**:
   Edit `lib/core/config/supabase_config.dart`:
   ```dart
   static const String url = 'https://your-project-id.supabase.co';
   static const String anonKey = 'your-anon-key-here';
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   ```bash
   flutter run -d chrome
   ```

## 📁 Project Structure

```
flutter_app/
├── lib/
│   ├── core/
│   │   ├── config/          # Configuration files
│   │   └── services/        # Core services (device, storage)
│   ├── data/               # Data layer (repositories, models)
│   ├── domain/             # Business logic (entities, use cases)
│   └── presentation/       # UI layer (pages, widgets, providers)
│       ├── pages/          # Main pages
│       ├── widgets/        # Reusable widgets
│       └── providers/      # Riverpod providers
├── assets/                 # Images, animations, sounds
└── web/                   # Web-specific files
```

## 🔧 Key Features (Planned)

- [x] Anonymous device registration
- [ ] WOOP entry creation and editing
- [ ] 24-hour streak timer
- [ ] Real-time updates via Supabase
- [ ] Offline support with local caching
- [ ] Celebration animations (confetti, sounds)
- [ ] Progress analytics and charts
- [ ] Spanish localization (v1.1)

## 🎯 MVP User Stories

1. **US-1**: Device Registration - Anonymous device-bound authentication
2. **US-3**: Create WOOP - Enter Wish, Outcome, Obstacle, Plan
3. **US-4**: Edit WOOP - Modify draft before starting timer
4. **US-5**: Start Timer - Begin 24-hour craving timer
5. **US-6**: Stop Timer - Complete or log slip

## 🔐 Security & Privacy

- Anonymous authentication (no personal data required)
- Device-bound user sessions
- Row-level security in Supabase
- HIPAA-aligned data handling
- All data encrypted at rest and in transit

## 🚀 Deployment

The app is designed to be deployed to Cloudflare Pages:

1. Build for web: `flutter build web`
2. Deploy `build/web/` directory to Cloudflare Pages
3. Configure environment variables in Cloudflare

## 🧪 Development

### Running Tests
```bash
flutter test
```

### Code Generation (for Riverpod)
```bash
flutter packages pub run build_runner build
```

### Linting
```bash
flutter analyze
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart)
- [TouchGrass Project Documentation](../docs/)