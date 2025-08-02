# TouchGrass - Substance Use Disorder Recovery App

TouchGrass is a web application that empowers individuals with substance-use disorder (SUD) to ride out intense cravings using the evidence-based **WOOP** technique (Wish, Outcome, Obstacle, Plan) paired with a real-time 24-hour streak timer.

## 🏗️ Architecture

- **Primary Frontend**: Flutter Web (Single codebase, future mobile export)
- **Alternative Frontend**: Next.js (Development/testing purposes)
- **Backend**: Supabase (Postgres + Edge Functions + Realtime)
- **Authentication**: Anonymous device-bound JWT
- **Hosting**: Cloudflare Pages
- **State Management**: Riverpod (Flutter) / Zustand (Next.js)

## 🚀 Quick Start

### Prerequisites

1. **Flutter SDK** 3.x+ installed
2. **Node.js** 18+ installed
3. **Supabase project** configured

### Setup

1. **Clone and install dependencies**:
   ```bash
   npm install
   npm run flutter:get
   ```

2. **Configure Supabase**:
   - Copy `.env.local.example` to `.env.local`
   - Add your Supabase URL and anon key
   - Update `flutter_app/lib/core/config/supabase_config.dart`
   - Run the SQL migration in your Supabase dashboard

3. **Run the applications**:
   ```bash
   # Flutter Web (Primary)
   npm run flutter:dev
   
   # Next.js (Alternative)
   npm run dev
   ```

## 📁 Project Structure

```
touchgrassapp/
├── flutter_app/           # Primary Flutter Web application
│   ├── lib/
│   │   ├── core/          # Configuration, services
│   │   ├── data/          # Repositories, models
│   │   ├── domain/        # Business logic
│   │   └── presentation/  # UI (pages, widgets, providers)
│   └── web/               # Web build configuration
├── app/                   # Next.js pages (alternative frontend)
├── lib/                   # Shared utilities (TypeScript)
├── docs/                  # Project documentation
│   ├── architecture/      # System architecture
│   ├── prd/              # Product requirements
│   └── scrum/            # Sprint planning
└── supabase/             # Database schema and migrations
```

## 🎯 Key Features

### MVP (Current Sprint)
- [x] Anonymous device registration
- [ ] WOOP entry creation and editing
- [ ] 24-hour streak timer with persistence
- [ ] Basic progress tracking

### v1.0 (Planned)
- [ ] Real-time notifications (24h success, early slip)
- [ ] Celebration animations (confetti, sounds)
- [ ] Advanced analytics (cumulative charts, 7-day avg)
- [ ] PWA offline support

### v1.1 (Future)
- [ ] Spanish localization
- [ ] Enhanced security auditing
- [ ] Mobile app export

## 🔧 Development Scripts

### Flutter Commands
```bash
npm run flutter:dev      # Run Flutter in development
npm run flutter:build    # Build for production
npm run flutter:test     # Run Flutter tests
npm run flutter:analyze  # Lint Flutter code
```

### Next.js Commands
```bash
npm run dev      # Run Next.js development server
npm run build    # Build Next.js for production
npm run lint     # Lint Next.js code
```

## 🔐 Security & Privacy

- **Privacy by Design**: HIPAA-aligned encryption, minimal PII
- **Anonymous Access**: No email/account required
- **Device-Bound**: Data tied to device, not personal identity
- **Row-Level Security**: Database policies prevent data leakage
- **Audit Trail**: All CRUD operations logged

## 📊 Current Sprint Status

**Sprint 1 - MVP Core (24 points)**
- US-1: Device Registration (3 pts) - In Progress
- US-3: Create WOOP (5 pts) - Pending
- US-4: Edit WOOP (3 pts) - Pending  
- US-5: Start Timer (8 pts) - Pending
- US-6: Stop Timer (5 pts) - Pending

See `docs/scrum/sprint-1-board.md` for detailed progress.

## 🚀 Deployment

### Production Build
```bash
# Flutter Web (Primary)
npm run flutter:build
# Output: flutter_app/build/web/

# Next.js (Alternative)
npm run build
# Output: .next/
```

### Cloudflare Pages
1. Connect your repository to Cloudflare Pages
2. Set build command: `npm run flutter:build`
3. Set publish directory: `flutter_app/build/web`
4. Add environment variables in Cloudflare dashboard

## 📚 Documentation

- [Product Requirements](docs/prd/)
- [System Architecture](docs/architecture/)
- [Sprint Planning](docs/scrum/)
- [Flutter App Guide](flutter_app/README.md)
- [Supabase Setup](supabase/README.md)

## 🤝 Contributing

1. Check current sprint board in `docs/scrum/`
2. Pick up assigned user stories
3. Follow the Definition of Done in `docs/prd/definition-of-done.md`
4. Submit PR with tests and documentation

## 📄 License

Private project for TouchGrass application development.
