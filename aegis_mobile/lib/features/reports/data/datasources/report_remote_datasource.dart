import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_remote_datasource.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';
import 'package:aegis_mobile/features/reports/data/models/report_model.dart';

abstract class ReportRemoteDataSource {
  Future<List<ReportModel>> getReports();
  Future<ReportModel> getReportById(String id);
  Future<ReportModel> createReport(ReportModel report);
  Future<ReportModel> updateReport(ReportModel report);
  Future<bool> deleteReport(String id);
  Future<String> uploadPhoto(String filePath);
}

@LazySingleton(as: ReportRemoteDataSource)
class ReportRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ReportRemoteDataSource {
  ReportRemoteDataSourceImpl(super.dio);

  @override
  Future<List<ReportModel>> getReports() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.reports);
      return extractListData<ReportModel>(
        response,
        (json) => ReportModel.fromJson(json),
      );
    });
  }

  @override
  Future<ReportModel> getReportById(String id) async {
    return safeApiCall(() async {
      final response = await dio.get('${ApiEndpoints.reports}/$id');
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
        ApiEndpoints.reports,
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
        '${ApiEndpoints.reports}/${report.id}',
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
      await dio.delete('${ApiEndpoints.reports}/$id');
      return true;
    });
  }

  @override
  Future<String> uploadPhoto(String filePath) async {
    return safeApiCall(() async {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await dio.post(
        ApiEndpoints.uploadPhoto,
        data: formData,
      );
      final data = response.data as Map<String, dynamic>;
      return data['url'] as String? ?? data['data']['url'] as String;
    });
  }
}

