import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_remote_datasource.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';
import 'package:aegis_mobile/features/inspections/data/models/inspection_model.dart';

abstract class InspectionRemoteDataSource {
  Future<List<InspectionModel>> getInspections();
  Future<List<InspectionModel>> getMyInspections();
  Future<InspectionModel> getInspectionById(String id);
  Future<InspectionModel> createInspection(InspectionModel inspection);
  Future<InspectionModel> updateInspection(InspectionModel inspection);
  Future<bool> deleteInspection(String id);
  Future<InspectionModel> updateInspectionStatus(String id, String status);
}

@LazySingleton(as: InspectionRemoteDataSource)
class InspectionRemoteDataSourceImpl extends BaseRemoteDataSource
    implements InspectionRemoteDataSource {
  InspectionRemoteDataSourceImpl(super.dio);

  @override
  Future<List<InspectionModel>> getInspections() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.inspections);
      return extractListData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<List<InspectionModel>> getMyInspections() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.myInspections);
      return extractListData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<InspectionModel> getInspectionById(String id) async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.inspection(id));
      return extractData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<InspectionModel> createInspection(InspectionModel inspection) async {
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.inspections,
        data: inspection.toJson(),
      );
      return extractData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<InspectionModel> updateInspection(InspectionModel inspection) async {
    return safeApiCall(() async {
      final response = await dio.put(
        ApiEndpoints.inspection(inspection.id),
        data: inspection.toJson(),
      );
      return extractData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<bool> deleteInspection(String id) async {
    return safeApiCall(() async {
      await dio.delete(ApiEndpoints.inspection(id));
      return true;
    });
  }

  @override
  Future<InspectionModel> updateInspectionStatus(String id, String status) async {
    return safeApiCall(() async {
      final response = await dio.patch(
        ApiEndpoints.inspectionStatus(id),
        data: {'status': status},
      );
      return extractData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }
}
