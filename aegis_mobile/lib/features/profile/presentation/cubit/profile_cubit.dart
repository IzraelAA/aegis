import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:aegis_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:aegis_mobile/features/profile/domain/usecases/update_profile_usecase.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileEntity> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  });

  Future<void> loadProfile() async {
    emitLoading();

    final result = await getProfileUseCase(const NoParams());

    result.fold(
      (failure) => emitError(failure.message),
      (profile) => emitSuccess(profile),
    );
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    emitLoading();

    final result = await updateProfileUseCase(
      UpdateProfileParams(profile: profile),
    );

    result.fold(
      (failure) => emitError(failure.message),
      (updatedProfile) => emitSuccess(updatedProfile),
    );
  }
}

