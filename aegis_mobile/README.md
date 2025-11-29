# Peken

A Flutter boilerplate project with clean architecture.

## Features

- ✅ **Clean Architecture** - Data, Domain, and Presentation layers
- ✅ **State Management** - Cubit/BLoC with base classes
- ✅ **Dependency Injection** - GetIt + Injectable
- ✅ **Network Layer** - Dio with interceptors and error handling
- ✅ **Local Storage** - Hive for persistent storage
- ✅ **Routing** - Auto Route for navigation
- ✅ **Functional Programming** - Dartz for Either types
- ✅ **Typography & Theming** - Google Fonts with custom theme
- ✅ **Reusable Widgets** - Button, Dialog, Loading, TextFormField, Header

## Project Structure

```
lib/
├── app/                          # App configuration
│   ├── app.dart                  # Main app widget
│   └── app_theme.dart            # Theme configuration
├── core/                         # Core modules
│   ├── data/                     # Base data classes
│   │   ├── datasource/
│   │   └── model/
│   ├── di/                       # Dependency injection
│   │   ├── injection.dart
│   │   ├── injection.config.dart (generated)
│   │   └── register_module.dart
│   ├── domain/                   # Base domain classes
│   │   ├── entity/
│   │   ├── repository/
│   │   └── usecase/
│   ├── local_storage/            # Hive storage
│   │   ├── hive_storage.dart
│   │   └── storage_keys.dart
│   ├── network/                  # Network layer
│   │   ├── api_endpoints.dart
│   │   ├── api_interceptor.dart
│   │   ├── api_response.dart
│   │   ├── dio_client.dart
│   │   ├── exception_handler.dart
│   │   ├── failure.dart
│   │   └── network_info.dart
│   ├── route/                    # Routing
│   │   ├── app_router.dart
│   │   ├── app_router.gr.dart (generated)
│   │   └── route_guard.dart
│   └── state_management/         # State management
│       ├── base_cubit.dart
│       ├── base_state.dart
│       └── cubit_observer.dart
├── features/                     # Feature modules
│   ├── home/
│   ├── splash/
│   └── sample/                   # Sample feature (template)
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── cubit/
│           ├── pages/
│           └── widgets/
├── utils/                        # Utilities
│   ├── app_color.dart
│   ├── app_status.dart
│   ├── app_typography.dart
│   ├── extensions/
│   │   ├── context_extension.dart
│   │   ├── date_extension.dart
│   │   └── string_extension.dart
│   ├── validators/
│   │   └── form_validators.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_common_dialog.dart
│       ├── app_header.dart
│       ├── app_loading.dart
│       └── app_text_form_field.dart
└── main.dart                     # Entry point
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.5.0
- Dart SDK ^3.5.0

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd peken
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Dependencies

### Core Dependencies

| Package | Description |
|---------|-------------|
| `flutter_bloc` | State management |
| `equatable` | Value equality |
| `get_it` | Service locator |
| `injectable` | Dependency injection |
| `dio` | HTTP client |
| `auto_route` | Navigation |
| `dartz` | Functional programming |
| `google_fonts` | Typography |
| `hive` / `hive_flutter` | Local storage |
| `shimmer` | Loading effects |

### Dev Dependencies

| Package | Description |
|---------|-------------|
| `build_runner` | Code generation |
| `auto_route_generator` | Route generation |
| `injectable_generator` | DI generation |
| `hive_generator` | Hive adapter generation |

## Usage

### Adding a New Feature

1. Create the feature folder structure:
```
lib/features/your_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubit/
    ├── pages/
    └── widgets/
```

2. Create your entity (domain layer):
```dart
class YourEntity extends BaseEntity {
  final String id;
  final String name;
  
  const YourEntity({required this.id, required this.name});
  
  @override
  List<Object?> get props => [id, name];
}
```

3. Create your model (data layer):
```dart
class YourModel extends BaseModel<YourEntity> {
  // ... implementation
}
```

4. Create repository interface (domain) and implementation (data)

5. Create use cases

6. Create cubit for state management

7. Run build_runner to generate DI code:
```bash
dart run build_runner build
```

### Adding a New Route

1. Create your page with `@RoutePage()` annotation:
```dart
@RoutePage()
class YourPage extends StatelessWidget {
  // ...
}
```

2. Add route to `app_router.dart`:
```dart
AutoRoute(page: YourRoute.page),
```

3. Run build_runner:
```bash
dart run build_runner build
```

### Using Base Cubit

```dart
@injectable
class YourCubit extends BaseCubit<YourEntity> {
  final YourUseCase useCase;
  
  YourCubit(this.useCase);
  
  Future<void> load() async {
    emitLoading();
    
    final result = await useCase(NoParams());
    
    result.fold(
      (failure) => emitError(failure.message),
      (data) => emitSuccess(data),
    );
  }
}
```

### Using Widgets

```dart
// Button
AppButton.primary(
  text: 'Click Me',
  onPressed: () {},
)

// Dialog
AppCommonDialog.confirm(
  context: context,
  title: 'Confirm',
  message: 'Are you sure?',
  onConfirm: () {},
)

// Loading
AppLoading()
AppLoadingOverlay(isLoading: true, child: widget)

// Text Form Field
AppTextFormField.email(
  controller: emailController,
  validator: FormValidators.email,
)
```

## Configuration

### API Configuration

Update `lib/core/network/dio_client.dart`:
```dart
static const String baseUrl = 'https://your-api.com';
```

### Theme Configuration

Update colors in `lib/utils/app_color.dart` and typography in `lib/utils/app_typography.dart`.

## Code Generation

After making changes to annotated files, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

For watch mode during development:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## License

This project is licensed under the MIT License.
