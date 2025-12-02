import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_remote_datasource.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';
import 'package:aegis_mobile/features/reports/data/models/report_model.dart';

abstract class ReportRemoteDataSource {
  Future<List<ReportModel>> getReports();
  Future<List<ReportModel>> getMyReports();
  Future<ReportModel> getReportById(String id);
  Future<ReportModel> createReport(ReportModel report);
  Future<ReportModel> updateReport(ReportModel report);
  Future<bool> deleteReport(String id);
  Future<List<ReportModel>> searchReports(String query);
  Future<ReportModel> updateInvestigation(String id, Map<String, dynamic> data);
}

@LazySingleton(as: ReportRemoteDataSource)
class ReportRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ReportRemoteDataSource {
  ReportRemoteDataSourceImpl(super.dio);

  @override
  Future<List<ReportModel>> getReports() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.incidents);
      return extractListData<ReportModel>(
        response,
        (json) => ReportModel.fromJson(json),
      );
    });
  }

  @override
  Future<List<ReportModel>> getMyReports() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.myIncidents);
      return extractListData<ReportModel>(
        response,
        (json) => ReportModel.fromJson(json),
      );
    });
  }

  @override
  Future<ReportModel> getReportById(String id) async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.incident(id));
      return extractData<ReportModel>(
        response,
        (json) => ReportModel.fromJson(json),
      );
    });
  }

  @override
  Future<ReportModel> createReport(ReportModel report) async {
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.incidents,
        data: report.toJson(),
      );
      return extractData<ReportModel>(
        response,
        (json) => ReportModel.fromJson(json),
      );
    });
  }

  @override
  Future<ReportModel> updateReport(ReportModel report) async {
    return safeApiCall(() async {
      final response = await dio.put(
        ApiEndpoints.incident(report.id),
        data: report.toJson(),
      );
      return extractData<ReportModel>(
        response,
        (json) => ReportModel.fromJson(json),
      );
    });
  }

  @override
  Future<bool> deleteReport(String id) async {
    return safeApiCall(() async {
      await dio.delete(ApiEndpoints.incident(id));
      return true;
    });
  }

  @override
  Future<List<ReportModel>> searchReports(String query) async {
    return safeApiCall(() async {
      final response = await dio.get(
        ApiEndpoints.searchIncidents,
        queryParameters: {'q': query},
      );
      return extractListData<ReportModel>(
        response,
        (json) => ReportModel.fromJson(json),
      );
    });
  }

  @override
  Future<ReportModel> updateInvestigation(
      String id, Map<String, dynamic> data) async {
    return safeApiCall(() async {
      final response = await dio.patch(
        ApiEndpoints.incidentInvestigation(id),
        data: data,
      );
      return extractData<ReportModel>(
        response,
        (json) => ReportModel.fromJson(json),
      );
    });
  }
}
