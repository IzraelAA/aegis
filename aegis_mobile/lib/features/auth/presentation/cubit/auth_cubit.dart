import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:aegis_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:aegis_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:aegis_mobile/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:aegis_mobile/features/auth/domain/usecases/auto_login_usecase.dart';

@injectable
class AuthCubit extends BaseCubit<UserEntity> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final AutoLoginUseCase autoLoginUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.autoLoginUseCase,
  });

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emitLoading();

    final result = await loginUseCase(LoginParams(
      email: email,
      password: password,
    ));

    await result.fold(
      (failure) async => emitError(failure.message),
      (token) async {
        // After successful login, get user data
        await getCurrentUser();
      },
    );
  }

  /// Login with demo account credentials
  Future<void> loginWithDemo() async {
    emitLoading();

    final result = await loginUseCase(const LoginParams(
      email: 'demo@aegis.com',
      password: 'demo123',
    ));

    await result.fold(
      (failure) async => emitError(failure.message),
      (token) async {
        // After successful login, get user data
        await getCurrentUser();
      },
    );
  }

  Future<void> getCurrentUser() async {
    emitLoading();

    final result = await getCurrentUserUseCase(const NoParams());

    result.fold(
      (failure) => emitError(failure.message),
      (user) => emitSuccess(user),
    );
  }

  Future<void> autoLogin() async {
    emitLoading();

    final result = await autoLoginUseCase(const NoParams());

    result.fold(
      (failure) => emitError(failure.message),
      (user) => emitSuccess(user),
    );
  }

  Future<void> logout() async {
    emitLoading();

    final result = await logoutUseCase(const NoParams());

    result.fold(
      (failure) => emitError(failure.message),
      (_) => reset(),
    );
  }
}

