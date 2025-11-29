import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/network/dio_client.dart';
import 'package:aegis_mobile/core/local_storage/hive_storage.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => DioClient.createDio();

  @preResolve
  Future<HiveStorage> get hiveStorage => HiveStorage.init();
}
