import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_remote_datasource.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';
import 'package:aegis_mobile/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<String> updateAvatar(String filePath);
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(super.dio);

  @override
  Future<ProfileModel> getProfile() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.me);
      return extractData<ProfileModel>(
        response,
        (json) => ProfileModel.fromJson(json),
      );
    });
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    return safeApiCall(() async {
      final response = await dio.put(
        ApiEndpoints.me,
        data: profile.toJson(),
      );
      return extractData<ProfileModel>(
        response,
        (json) => ProfileModel.fromJson(json),
      );
    });
  }

  @override
  Future<String> updateAvatar(String filePath) async {
    return safeApiCall(() async {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });
      final response = await dio.put(
        ApiEndpoints.me,
        data: formData,
      );
      final data = response.data as Map<String, dynamic>;
      return data['avatar'] as String? ??
          data['url'] as String? ??
          data['data']?['avatar'] as String? ??
          '';
    });
  }

  @override
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return safeApiCall(() async {
      await dio.put(
        ApiEndpoints.me,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
      return true;
    });
  }
}
