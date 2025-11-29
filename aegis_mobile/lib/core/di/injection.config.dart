// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/auto_login_usecase.dart' as _i695;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/refresh_token_usecase.dart'
    as _i157;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/inspections/data/datasources/inspection_local_datasource.dart'
    as _i844;
import '../../features/inspections/data/datasources/inspection_remote_datasource.dart'
    as _i605;
import '../../features/inspections/data/repositories/inspection_repository_impl.dart'
    as _i329;
import '../../features/inspections/domain/repositories/inspection_repository.dart'
    as _i165;
import '../../features/inspections/domain/usecases/get_inspections_usecase.dart'
    as _i387;
import '../../features/inspections/domain/usecases/submit_inspection_usecase.dart'
    as _i809;
import '../../features/inspections/domain/usecases/update_inspection_usecase.dart'
    as _i804;
import '../../features/inspections/presentation/cubit/inspection_form_cubit.dart'
    as _i695;
import '../../features/inspections/presentation/cubit/inspection_list_cubit.dart'
    as _i870;
import '../../features/notifications/data/datasources/notification_local_datasource.dart'
    as _i372;
import '../../features/notifications/data/datasources/notification_remote_datasource.dart'
    as _i923;
import '../../features/notifications/data/repositories/notification_repository_impl.dart'
    as _i361;
import '../../features/notifications/domain/repositories/notification_repository.dart'
    as _i367;
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart'
    as _i587;
import '../../features/notifications/domain/usecases/mark_notification_read_usecase.dart'
    as _i6;
import '../../features/notifications/presentation/cubit/notification_cubit.dart'
    as _i459;
import '../../features/profile/data/datasources/profile_remote_datasource.dart'
    as _i327;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/get_profile_usecase.dart'
    as _i965;
import '../../features/profile/domain/usecases/update_profile_usecase.dart'
    as _i478;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/realtime/presentation/cubit/realtime_alert_cubit.dart'
    as _i551;
import '../../features/reports/data/datasources/report_local_datasource.dart'
    as _i676;
import '../../features/reports/data/datasources/report_remote_datasource.dart'
    as _i995;
import '../../features/reports/data/repositories/report_repository_impl.dart'
    as _i246;
import '../../features/reports/domain/repositories/report_repository.dart'
    as _i939;
import '../../features/reports/domain/usecases/create_report_usecase.dart'
    as _i1053;
import '../../features/reports/domain/usecases/get_report_by_id_usecase.dart'
    as _i37;
import '../../features/reports/domain/usecases/get_reports_usecase.dart'
    as _i369;
import '../../features/reports/domain/usecases/sync_offline_reports_usecase.dart'
    as _i268;
import '../../features/reports/presentation/cubit/create_report_cubit.dart'
    as _i491;
import '../../features/reports/presentation/cubit/report_detail_cubit.dart'
    as _i83;
import '../../features/reports/presentation/cubit/report_list_cubit.dart'
    as _i572;
import '../../features/sample/data/datasources/sample_local_datasource.dart'
    as _i470;
import '../../features/sample/data/datasources/sample_remote_datasource.dart'
    as _i103;
import '../../features/sample/data/repositories/sample_repository_impl.dart'
    as _i647;
import '../../features/sample/domain/repositories/sample_repository.dart'
    as _i672;
import '../../features/sample/domain/usecases/get_sample_by_id_usecase.dart'
    as _i908;
import '../../features/sample/domain/usecases/get_samples_usecase.dart'
    as _i1043;
import '../../features/sample/presentation/cubit/sample_cubit.dart' as _i686;
import '../../features/sample/presentation/cubit/sample_detail_cubit.dart'
    as _i1036;
import '../auth/demo_account_service.dart' as _i119;
import '../local_storage/hive_storage.dart' as _i1023;
import '../network/websocket_service.dart' as _i436;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i1023.HiveStorage>(
      () => registerModule.hiveStorage,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i119.DemoAccountService>(
        () => _i119.DemoAccountService());
    gh.lazySingleton<_i103.SampleRemoteDataSource>(
        () => _i103.SampleRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i327.ProfileRemoteDataSource>(
        () => _i327.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i605.InspectionRemoteDataSource>(
        () => _i605.InspectionRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i995.ReportRemoteDataSource>(
        () => _i995.ReportRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i436.WebSocketService>(
        () => _i436.WebSocketService(gh<_i1023.HiveStorage>()));
    gh.lazySingleton<_i923.NotificationRemoteDataSource>(
        () => _i923.NotificationRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i119.DemoAccountService>(),
            ));
    gh.lazySingleton<_i894.ProfileRepository>(() => _i334.ProfileRepositoryImpl(
        remoteDataSource: gh<_i327.ProfileRemoteDataSource>()));
    gh.factory<_i551.RealTimeAlertCubit>(
        () => _i551.RealTimeAlertCubit(gh<_i436.WebSocketService>()));
    gh.lazySingleton<_i470.SampleLocalDataSource>(
        () => _i470.SampleLocalDataSourceImpl(gh<_i1023.HiveStorage>()));
    gh.lazySingleton<_i844.InspectionLocalDataSource>(
        () => _i844.InspectionLocalDataSourceImpl(gh<_i1023.HiveStorage>()));
    gh.lazySingleton<_i992.AuthLocalDataSource>(
        () => _i992.AuthLocalDataSourceImpl(gh<_i1023.HiveStorage>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          remoteDataSource: gh<_i161.AuthRemoteDataSource>(),
          localDataSource: gh<_i992.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i372.NotificationLocalDataSource>(
        () => _i372.NotificationLocalDataSourceImpl(gh<_i1023.HiveStorage>()));
    gh.lazySingleton<_i478.UpdateProfileUseCase>(
        () => _i478.UpdateProfileUseCase(gh<_i894.ProfileRepository>()));
    gh.lazySingleton<_i965.GetProfileUseCase>(
        () => _i965.GetProfileUseCase(gh<_i894.ProfileRepository>()));
    gh.lazySingleton<_i676.ReportLocalDataSource>(
        () => _i676.ReportLocalDataSourceImpl(gh<_i1023.HiveStorage>()));
    gh.lazySingleton<_i157.RefreshTokenUseCase>(
        () => _i157.RefreshTokenUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i188.LoginUseCase>(
        () => _i188.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i48.LogoutUseCase>(
        () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i695.AutoLoginUseCase>(
        () => _i695.AutoLoginUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i17.GetCurrentUserUseCase>(
        () => _i17.GetCurrentUserUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i367.NotificationRepository>(
        () => _i361.NotificationRepositoryImpl(
              remoteDataSource: gh<_i923.NotificationRemoteDataSource>(),
              localDataSource: gh<_i372.NotificationLocalDataSource>(),
            ));
    gh.lazySingleton<_i672.SampleRepository>(() => _i647.SampleRepositoryImpl(
          remoteDataSource: gh<_i103.SampleRemoteDataSource>(),
          localDataSource: gh<_i470.SampleLocalDataSource>(),
        ));
    gh.lazySingleton<_i587.GetNotificationsUseCase>(() =>
        _i587.GetNotificationsUseCase(gh<_i367.NotificationRepository>()));
    gh.lazySingleton<_i6.MarkNotificationReadUseCase>(() =>
        _i6.MarkNotificationReadUseCase(gh<_i367.NotificationRepository>()));
    gh.lazySingleton<_i939.ReportRepository>(() => _i246.ReportRepositoryImpl(
          remoteDataSource: gh<_i995.ReportRemoteDataSource>(),
          localDataSource: gh<_i676.ReportLocalDataSource>(),
        ));
    gh.lazySingleton<_i165.InspectionRepository>(
        () => _i329.InspectionRepositoryImpl(
              remoteDataSource: gh<_i605.InspectionRemoteDataSource>(),
              localDataSource: gh<_i844.InspectionLocalDataSource>(),
            ));
    gh.factory<_i36.ProfileCubit>(() => _i36.ProfileCubit(
          getProfileUseCase: gh<_i965.GetProfileUseCase>(),
          updateProfileUseCase: gh<_i478.UpdateProfileUseCase>(),
        ));
    gh.lazySingleton<_i369.GetReportsUseCase>(
        () => _i369.GetReportsUseCase(gh<_i939.ReportRepository>()));
    gh.lazySingleton<_i37.GetReportByIdUseCase>(
        () => _i37.GetReportByIdUseCase(gh<_i939.ReportRepository>()));
    gh.lazySingleton<_i268.SyncOfflineReportsUseCase>(
        () => _i268.SyncOfflineReportsUseCase(gh<_i939.ReportRepository>()));
    gh.lazySingleton<_i1053.CreateReportUseCase>(
        () => _i1053.CreateReportUseCase(gh<_i939.ReportRepository>()));
    gh.lazySingleton<_i1043.GetSamplesUseCase>(
        () => _i1043.GetSamplesUseCase(gh<_i672.SampleRepository>()));
    gh.lazySingleton<_i908.GetSampleByIdUseCase>(
        () => _i908.GetSampleByIdUseCase(gh<_i672.SampleRepository>()));
    gh.factory<_i1036.SampleDetailCubit>(() => _i1036.SampleDetailCubit(
        getSampleByIdUseCase: gh<_i908.GetSampleByIdUseCase>()));
    gh.factory<_i686.SampleCubit>(() => _i686.SampleCubit(
          getSamplesUseCase: gh<_i1043.GetSamplesUseCase>(),
          getSampleByIdUseCase: gh<_i908.GetSampleByIdUseCase>(),
        ));
    gh.factory<_i117.AuthCubit>(() => _i117.AuthCubit(
          loginUseCase: gh<_i188.LoginUseCase>(),
          logoutUseCase: gh<_i48.LogoutUseCase>(),
          getCurrentUserUseCase: gh<_i17.GetCurrentUserUseCase>(),
          autoLoginUseCase: gh<_i695.AutoLoginUseCase>(),
        ));
    gh.factory<_i572.ReportListCubit>(() => _i572.ReportListCubit(
          getReportsUseCase: gh<_i369.GetReportsUseCase>(),
          syncOfflineReportsUseCase: gh<_i268.SyncOfflineReportsUseCase>(),
        ));
    gh.factory<_i459.NotificationCubit>(() => _i459.NotificationCubit(
          getNotificationsUseCase: gh<_i587.GetNotificationsUseCase>(),
          markNotificationReadUseCase: gh<_i6.MarkNotificationReadUseCase>(),
        ));
    gh.lazySingleton<_i809.SubmitInspectionUseCase>(
        () => _i809.SubmitInspectionUseCase(gh<_i165.InspectionRepository>()));
    gh.lazySingleton<_i387.GetInspectionsUseCase>(
        () => _i387.GetInspectionsUseCase(gh<_i165.InspectionRepository>()));
    gh.lazySingleton<_i804.UpdateInspectionUseCase>(
        () => _i804.UpdateInspectionUseCase(gh<_i165.InspectionRepository>()));
    gh.factory<_i83.ReportDetailCubit>(() => _i83.ReportDetailCubit(
        getReportByIdUseCase: gh<_i37.GetReportByIdUseCase>()));
    gh.factory<_i491.CreateReportCubit>(() => _i491.CreateReportCubit(
        createReportUseCase: gh<_i1053.CreateReportUseCase>()));
    gh.factory<_i870.InspectionListCubit>(() => _i870.InspectionListCubit(
        getInspectionsUseCase: gh<_i387.GetInspectionsUseCase>()));
    gh.factory<_i695.InspectionFormCubit>(() => _i695.InspectionFormCubit(
          updateInspectionUseCase: gh<_i804.UpdateInspectionUseCase>(),
          submitInspectionUseCase: gh<_i809.SubmitInspectionUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
