# CatBreeds

> Project developed as a technical test for the Flutter Developer hiring process at Pragma.

A Flutter app to discover and learn about cat breeds. It lets you browse and search cat breeds, and view detailed info (origin, life span, weight, height, temperament, history) for each one.

## Features

- Splash screen with animated intro.
- Cat breed list with debounced search and infinite scroll pagination.
- Cat breed detail page.
- Loading, empty and error states for every screen.

## Architecture

The app follows a layered, feature-based **Clean Architecture**, keeping the domain free of framework/UI details and every dependency pointing inward:

```
lib/
├── core/                  # Cross-cutting concerns shared by every feature
│   ├── di/                # Dependency injection setup (GetIt service locator)
│   ├── either/            # Either<L, R> for functional error handling
│   ├── env/               # Build-time secrets (envied)
│   ├── error/             # Failure — domain-level error type
│   ├── http/              # Minimal HTTP client + result mapping
│   ├── router/            # go_router navigation graph
│   └── theme/             # Colors, text styles, ThemeData
├── shared/widgets/        # Reusable UI components used across features
└── features/
    └── <feature>/
        ├── data/          # Models (DTOs), remote data sources, repository impl
        ├── domain/        # Entities and repository interfaces (no Flutter/HTTP deps)
        └── presentation/  # Pages, widgets, BLoCs (state management)
```

- **State management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc), with events/states modeled as `freezed` unions.
- **Dependency injection:** [get_it](https://pub.dev/packages/get_it), wired once in `initDependencies()` (`lib/core/di/injection_container.dart`).
- **Navigation:** [go_router](https://pub.dev/packages/go_router).
- **Networking:** a thin wrapper around `package:http` (`CoreHttp`) that maps every failure mode (no connection, non-2xx response, bad JSON) into a typed `HttpResult`, later bridged into `Either<Failure, T>` for the domain layer.

## Getting started

### Prerequisites

- Flutter `3.44.8` (stable channel) / Dart `^3.12.2` (see `pubspec.yaml`) — the version this project was built and tested with.
- A [TheCatAPI](https://thecatapi.com/) API key.

### Setup

1. Install dependencies:
   ```sh
   flutter pub get
   ```
2. Copy `.env.example` to `.env` and fill in your API key:
   ```sh
   cp .env.example .env
   ```
   ```
   API=https://api.thecatapi.com/v1/
   API_KEY=<your-cat-api-key>
   ```
3. Generate the code that depends on `.env`, `freezed` and `json_serializable` (also git-ignored, so this step is required after a fresh clone or whenever a model/bloc/event changes):
   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Testing

The project has three layers of automated tests:

| Layer | Location | Run with |
|---|---|---|
| Unit | `test/core/**`, `test/features/**` (data/domain) | `flutter test` |
| Widget | `test/features/**` (presentation) | `flutter test` |
| Functional (end-to-end) | `integration_test/` | `flutter test integration_test/app_test.dart -d <device>` |

Run everything and generate coverage:

```sh
flutter test --coverage
```

## Dependencies

| Package | Purpose |
|---|---|
| [flutter_bloc](https://pub.dev/packages/flutter_bloc) | State management (BLoC) for the list and detail features |
| [go_router](https://pub.dev/packages/go_router) | Declarative navigation (splash → list → detail) |
| [get_it](https://pub.dev/packages/get_it) | Service locator / dependency injection |
| [http](https://pub.dev/packages/http) | HTTP client wrapped by `CoreHttp` |
| [freezed_annotation](https://pub.dev/packages/freezed_annotation) + [freezed](https://pub.dev/packages/freezed) *(dev)* | Immutable unions for `Either`, BLoC events/states, and data models |
| [json_annotation](https://pub.dev/packages/json_annotation) + [json_serializable](https://pub.dev/packages/json_serializable) *(dev)* | `fromJson`/`toJson` codegen for API models (`CatModel`, `CatImageModel`) |
| [envied](https://pub.dev/packages/envied) + [envied_generator](https://pub.dev/packages/envied_generator) *(dev)* | Type-safe, obfuscated access to `.env` values at build time |
| [google_fonts](https://pub.dev/packages/google_fonts) | App typography (Plus Jakarta Sans) |
| [skeletonizer](https://pub.dev/packages/skeletonizer) | Loading skeletons for the list and detail screens |
| [build_runner](https://pub.dev/packages/build_runner) *(dev)* | Runs the codegen above |

**Testing:**

| Package | Purpose |
|---|---|
| [flutter_test](https://pub.dev/packages/flutter_test) | Unit and widget tests |
| [integration_test](https://pub.dev/packages/integration_test) | Functional/end-to-end test (`integration_test/app_test.dart`) |
| [mocktail](https://pub.dev/packages/mocktail) | Mocking repositories/data sources/HTTP client in tests |
| [bloc_test](https://pub.dev/packages/bloc_test) | BLoC state-sequence assertions |
| [flutter_lints](https://pub.dev/packages/flutter_lints) *(dev)* | Static analysis rules (`analysis_options.yaml`) |
