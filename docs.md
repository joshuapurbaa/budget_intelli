
<!-- clean architecture -->

View: screens (call event) --- BLOC ---> Domain: usecases --- repository (only interface) ---
entity <--- Data: repository implementation --- data sources (remote, local) --- models

Example:
View: sign_up_screen.dart (call event) ---> Bloc: sign_up_event.dart --- sign_up_bloc.dart ---
sign_up_state.dart ---> Domain: user_sign_up.dart

<!-- Example -->

Domain

1. buat entity di user_intellie.dart
2. definisikan interface repository di auth_repository.dart
3. buat usecase user_signup.dart

Data

4. buat model user_intellie_model.dart
5. buat auth_remote_datasources.dart
6. buat auth_repository_impl.dart

View

7. buat bloc auth_bloc.dart
8. bloc akan berkomunikasi dengan usecase
9. implementasi bloc di ui

<!-- Build appbundle -->
flutter build appbundle --obfuscate --split-debug-info --release --dart-define=env=prod

<!-- create splash: run this command -->
dart run flutter_native_splash:create 

<!-- get the SHA-1 -->
./gradlew signingReport

flutter pub run build_runner build --delete-conflicting-outputs