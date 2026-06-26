# AGENTS.md — gastos_personales

## Quick start

```bash
flutter pub get
flutter run           # picks up ENV from env.dart (dev → ngrok)
flutter run --dart-define=ENV=production
```

**Adding dependencies**: Always use `flutter pub add <package>`, never edit `pubspec.yaml` manually.

No test suite exists (`test/` directory absent).

## Architecture

Clean Architecture + BLoC. Each feature under `lib/layers/<feature>/`:

| Layer | Path | Content |
|-------|------|---------|
| Domain | `domain/entity/`, `domain/repository/`, `domain/usecase/` | Entities, abstract repos, use cases |
| Data | `data/repository_impl.dart`, `data/dto/`, `data/source/network/` | Dio API calls, DTO mappers |
| Presentation | `lib/presentation/screens/` | UI + `bloc/<feature>/` BLoCs |

Entrypoint: `lib/main.dart` → splash (`/`) → after 3s auto-navigates to `/signin`.

## Navigation

Named routes in `lib/navigation/route.dart` as string constants. `RouteGenerator` in `lib/navigation/navigation_app.dart` handles `onGenerateRoute`.

## API layer

- **Auth**: POST `/auth/login` → `response.data.data.accessToken`
- **Token**: Stored/read via `TokenStorage` (`shared_preferences`); each API class manually reads `TokenStorage.getToken()` and attaches `Authorization: Bearer <token>` header — no Dio interceptor.
- **Endpoints**: `lib/util/api_endpoints.dart` builds URLs from `Env.baseUrl` (default: `development` → ngrok tunnel).
- **No error mapping layer** — repos/APIs throw raw `Exception(...)` strings. BLoCs parse them with string matching (`contains('401')`, `contains('SocketException')`).

## Localization

ARB sources in `lib/l10n/`:
```bash
flutter gen-l10n   # regenerates app_localizations*.dart from *.arb
```
Config: `lib/l10n/l10n.yaml` (`synthetic-package: false`). Use `AppLocalizations.of(context)!.someKey`.

## Linting

Based on `flutter_lints`. Overrides in `analysis_options.yaml` ignore:
`must_be_immutable`, `strict_top_level_inference`, `unnecessary_underscores`, `use_build_context_synchronously`.

## Dependencies (key)

- State: `flutter_bloc ^9.1.1`, `bloc ^9.2.1`, `equatable ^2.0.8`
- HTTP: `dio ^5.9.2`
- Local: `shared_preferences ^2.5.3`
- Camera: `camera ^0.12.0+1`, `google_mlkit_text_recognition ^0.15.1`, `permission_handler ^12.0.3`
- UI: `flutter_screenutil ^5.9.0`, `font_awesome_flutter ^11.0.0`, `intl ^0.20.2`
- SDK: Dart `^3.12.2`, Material 3
