# 🚀 GitHub Profile Explorer (Flutter)

A modern, production-grade Flutter application built to search, explore, and analyze GitHub user profiles and public repositories. Built with **Clean Architecture**, **BLoC (`flutter_bloc`)** state management, and **`get_it`** dependency injection.

---

## ✨ Features

### 1. 🔍 Search Screen
- **GitHub Username Search**: Search any developer or organization handle in real-time.
- **Async State Handling**:
  - **Initial / Empty State**: Welcome banner with quick-select developer chips (`flutter`, `torvalds`, `google`, `shadcn`, `mitchellh`, `antfu`).
  - **Loading State**: Smooth shimmering skeleton placeholders (`UserProfileShimmer`).
  - **Error State**: Context-aware error views for `404 User Not Found`, `403 Rate Limit Exceeded`, `Network / Offline`, `Timeout`, and `Server Errors` with an instant retry action.
  - **Data State**: Rich profile cards displaying cached avatar, name, `@handle`, hireable badge, org tag, bio, company, location, website link, twitter link, joined date, and interactive stats.
- **Direct Navigation**: Tap "View Repositories" or the repo count chip to transition to the Repositories Screen.

### 2. 📂 Repositories Screen
- **Comprehensive Repo List**: Fetches public repositories (`https://api.github.com/users/{username}/repos`).
- **Dynamic Sorting**:
  - ⭐ Most Stars (Default)
  - 🕒 Recently Updated
  - 🍴 Most Forks
  - 🔤 Name (A–Z)
- **Live Filtering**:
  - Search keyword filtering across repository names, descriptions, languages, and topic tags.
  - Horizontally scrollable language filter chips with official GitHub language colors.
- **Repository Cards**: Shows stars, forks, language badges, topics, and relative timestamps ("2d ago", "3w ago").
- **Deep-Dive Bottom Sheet**: Tap any repository card to view complete metrics, licenses, and direct "Open in GitHub" browser links.

### 3. 🕒 Recent Searches (Bonus Requirement)
- **Local Persistence**: Stores recently searched usernames using `SharedPreferences`.
- **Quick Re-search**: Tap any recent chip to replay the search instantly.
- **History Management**: Delete individual entries or clear all history with a single tap.

### 4. 🎨 Design & Theming
- **Dark & Light Mode**: GitHub-inspired color palettes with persistent state toggling via `ThemeCubit`.
- **Typography**: Modern typography powered by `Google Fonts` (Inter).
- **Responsive Layout**: Designed for seamless rendering across Android, iOS, macOS, and Web.

---

## 🏛️ Architecture & Project Structure

The project strictly follows **Clean Architecture** principles, separating business logic, domain entities, data access, and presentation layers:

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart          # GitHub API endpoints, timeouts, and headers
│   │   ├── app_colors.dart             # Dark/Light color tokens & gradients
│   │   └── app_theme.dart              # Material 3 ThemeData with GoogleFonts
│   ├── di/
│   │   └── injection_container.dart    # GetIt Service Locator setup
│   ├── errors/
│   │   ├── exceptions.dart             # Domain-specific exceptions
│   │   └── failures.dart               # Equatable UI failure models
│   ├── network/
│   │   └── api_client.dart             # Configured Dio HTTP client with interceptors
│   └── utils/
│       ├── date_formatter.dart         # Relative time & formatted dates
│       ├── language_colors.dart        # GitHub language color mappings
│       └── url_helper.dart             # Safe browser URL launcher
├── data/
│   ├── datasources/
│   │   ├── github_remote_datasource.dart       # Dio GitHub API caller
│   │   └── search_history_local_datasource.dart # SharedPreferences storage
│   ├── models/
│   │   ├── github_user_model.dart      # null-safe fromJson / toJson
│   │   └── github_repo_model.dart      # null-safe fromJson / toJson
│   └── repositories/
│       ├── github_repository_impl.dart
│       └── search_history_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── github_user.dart            # Equatable domain entity
│   │   └── github_repo.dart            # Equatable domain entity
│   ├── repositories/
│   │   ├── github_repository.dart      # Domain repository contract
│   │   └── search_history_repository.dart # Domain repository contract
│   └── usecases/
│       ├── get_user_usecase.dart       # User profile use case
│       ├── get_user_repos_usecase.dart # Repositories fetch use case
│       └── search_history_usecases.dart# Search history CRUD use cases
├── presentation/
│   ├── blocs/
│   │   ├── search/
│   │   │   ├── search_bloc.dart        # Profile search state machine
│   │   │   ├── search_event.dart
│   │   │   └── search_state.dart
│   │   ├── repositories/
│   │   │   ├── repositories_bloc.dart  # Repo filtering & sorting state machine
│   │   │   ├── repositories_event.dart
│   │   │   └── repositories_state.dart
│   │   ├── recent_searches/
│   │   │   ├── recent_searches_bloc.dart # Recent history state machine
│   │   │   ├── recent_searches_event.dart
│   │   │   └── recent_searches_state.dart
│   │   └── theme/
│   │       ├── theme_cubit.dart        # Dark / Light theme cubit
│   │       └── theme_state.dart
│   ├── screens/
│   │   ├── search/
│   │   │   ├── search_screen.dart
│   │   │   └── widgets/
│   │   │       ├── search_bar_widget.dart
│   │   │       ├── user_profile_card.dart
│   │   │       ├── user_profile_shimmer.dart
│   │   │       ├── empty_search_state.dart
│   │   │       ├── profile_stats_row.dart
│   │   │       └── recent_searches_widget.dart
│   │   └── repositories/
│   │       ├── repositories_screen.dart
│   │       └── widgets/
│   │           ├── repo_card.dart
│   │           ├── repo_shimmer_list.dart
│   │           ├── repo_sort_filter_bar.dart
│   │           └── repo_detail_modal.dart
│   └── widgets/
│       ├── custom_error_widget.dart
│       ├── custom_avatar.dart
│       └── stat_badge.dart
└── main.dart
```

---

## 🛠️ Tech Stack & Packages

| Package | Purpose |
|---|---|
| **`flutter_bloc`** | Predictable BLoC state management and event-driven architecture |
| **`get_it`** | Service locator for decoupled dependency injection |
| **`equatable`** | Value equality for immutable states, events, and domain entities |
| **`dio`** | Robust HTTP networking with status code mapping, timeouts, and headers |
| **`shared_preferences`** | Local persistent key-value storage for recent searches & theme mode |
| **`cached_network_image`** | Smooth image loading, disk caching, and memory optimization |
| **`shimmer`** | Beautiful skeleton loading animations for improved UX |
| **`intl`** | Human-readable relative time and date formatting |
| **`url_launcher`** | Opens external GitHub profiles and repository URLs |
| **`google_fonts`** | Typography powered by Inter font family |
| **`bloc_test` & `mocktail`** | BLoC testing and dependency mocking |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.5.0`
- Dart SDK `>=3.5.0 <4.0.0`

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd ethicfin_project
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run static analysis**:
   ```bash
   flutter analyze
   ```

4. **Run automated test suite**:
   ```bash
   flutter test test/
   ```

5. **Launch the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

The codebase includes comprehensive unit, BLoC, and widget tests:

```bash
flutter test
```

### Test Coverage Highlights
- ✅ **Domain Use Cases**: `GetUserUseCase`, `GetUserReposUseCase`, `SearchHistoryUseCases`
- ✅ **Data Models**: Null-safe `GithubUserModel` and `GithubRepoModel` parsing and serialization
- ✅ **BLoC State Testing (`bloc_test`)**:
  - `SearchBloc`: Initial, Loading, Loaded, Error (`404`, `Offline`, `RateLimit`)
  - `RepositoriesBloc`: Fetching, Stars/Updated/Name sorting, Language filters
  - `RecentSearchesBloc`: Load, Add, Remove, and Clear operations
- ✅ **Widget Tests**: Rendering `SearchScreen`, quick suggestions, recent searches, and searching workflows
