import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_remote_datasource.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';
import 'package:aegis_mobile/features/sample/data/models/sample_model.dart';

abstract class SampleRemoteDataSource {
  Future<List<SampleModel>> getSamples();
  Future<SampleModel> getSampleById(String id);
  Future<SampleModel> createSample(SampleModel sample);
  Future<SampleModel> updateSample(SampleModel sample);
  Future<bool> deleteSample(String id);
}

@LazySingleton(as: SampleRemoteDataSource)
class SampleRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SampleRemoteDataSource {
  SampleRemoteDataSourceImpl(super.dio);

  @override
  Future<List<SampleModel>> getSamples() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.users);
      return extractListData<SampleModel>(
        response,
        (json) => SampleModel.fromJson(json),
      );
    });
  }

  @override
  Future<SampleModel> getSampleById(String id) async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.user(id));
      return extractData<SampleModel>(
        response,
        (json) => SampleModel.fromJson(json),
      );
    });
  }

  @override
  Future<SampleModel> createSample(SampleModel sample) async {
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.users,
        data: sample.toJson(),
      );
      return extractData<SampleModel>(
        response,
        (json) => SampleModel.fromJson(json),
      );
    });
  }

  @override
  Future<SampleModel> updateSample(SampleModel sample) async {
    return safeApiCall(() async {
      final response = await dio.put(
        ApiEndpoints.user(sample.id),
        data: sample.toJson(),
      );
      return extractData<SampleModel>(
        response,
        (json) => SampleModel.fromJson(json),
      );
    });
  }

  @override
  Future<bool> deleteSample(String id) async {
    return safeApiCall(() async {
      await dio.delete(ApiEndpoints.user(id));
      return true;
    });
  }
}
