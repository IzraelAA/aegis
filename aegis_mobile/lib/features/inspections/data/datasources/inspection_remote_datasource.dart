import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_remote_datasource.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';
import 'package:aegis_mobile/features/inspections/data/models/inspection_model.dart';

abstract class InspectionRemoteDataSource {
  Future<List<InspectionModel>> getInspections();
  Future<InspectionModel> getInspectionById(String id);
  Future<List<InspectionModel>> getInspectionTemplates(String category);
  Future<InspectionModel> startInspection(InspectionModel template);
  Future<InspectionModel> updateInspection(InspectionModel inspection);
  Future<InspectionModel> submitInspection(InspectionModel inspection);
  Future<List<String>> getCategories();
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
  Future<InspectionModel> getInspectionById(String id) async {
    return safeApiCall(() async {
      final response = await dio.get('${ApiEndpoints.inspections}/$id');
      return extractData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<List<InspectionModel>> getInspectionTemplates(String category) async {
    return safeApiCall(() async {
      final response = await dio.get(
        ApiEndpoints.inspectionTemplates,
        queryParameters: {'category': category},
      );
      return extractListData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<InspectionModel> startInspection(InspectionModel template) async {
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.inspections,
        data: template.toJson(),
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
        '${ApiEndpoints.inspections}/${inspection.id}',
        data: inspection.toJson(),
      );
      return extractData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<InspectionModel> submitInspection(InspectionModel inspection) async {
    return safeApiCall(() async {
      final response = await dio.post(
        '${ApiEndpoints.inspections}/${inspection.id}/submit',
        data: inspection.toJson(),
      );
      return extractData<InspectionModel>(
        response,
        (json) => InspectionModel.fromJson(json),
      );
    });
  }

  @override
  Future<List<String>> getCategories() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.inspectionCategories);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final list = data['data'] ?? data['categories'] ?? [];
        return (list as List).map((e) => e.toString()).toList();
      }
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      return [];
    });
  }
}

