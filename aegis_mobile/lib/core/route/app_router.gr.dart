// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aegis_mobile/features/auth/presentation/pages/login_page.dart'
    as _i5;
import 'package:aegis_mobile/features/home/presentation/pages/home_page.dart'
    as _i2;
import 'package:aegis_mobile/features/inspections/presentation/pages/inspection_form_page.dart'
    as _i3;
import 'package:aegis_mobile/features/inspections/presentation/pages/inspection_list_page.dart'
    as _i4;
import 'package:aegis_mobile/features/notifications/presentation/pages/notification_list_page.dart'
    as _i6;
import 'package:aegis_mobile/features/profile/presentation/pages/profile_page.dart'
    as _i7;
import 'package:aegis_mobile/features/reports/presentation/pages/create_report_page.dart'
    as _i1;
import 'package:aegis_mobile/features/reports/presentation/pages/report_detail_page.dart'
    as _i8;
import 'package:aegis_mobile/features/reports/presentation/pages/report_list_page.dart'
    as _i9;
import 'package:aegis_mobile/features/splash/presentation/pages/splash_page.dart'
    as _i10;
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;

/// generated route for
/// [_i1.CreateReportPage]
class CreateReportRoute extends _i11.PageRouteInfo<void> {
  const CreateReportRoute({List<_i11.PageRouteInfo>? children})
      : super(
          CreateReportRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateReportRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.CreateReportPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.InspectionFormPage]
class InspectionFormRoute extends _i11.PageRouteInfo<InspectionFormRouteArgs> {
  InspectionFormRoute({
    _i12.Key? key,
    required String inspectionId,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          InspectionFormRoute.name,
          args: InspectionFormRouteArgs(
            key: key,
            inspectionId: inspectionId,
          ),
          rawPathParams: {'id': inspectionId},
          initialChildren: children,
        );

  static const String name = 'InspectionFormRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<InspectionFormRouteArgs>(
          orElse: () => InspectionFormRouteArgs(
              inspectionId: pathParams.getString('id')));
      return _i3.InspectionFormPage(
        key: args.key,
        inspectionId: args.inspectionId,
      );
    },
  );
}

class InspectionFormRouteArgs {
  const InspectionFormRouteArgs({
    this.key,
    required this.inspectionId,
  });

  final _i12.Key? key;

  final String inspectionId;

  @override
  String toString() {
    return 'InspectionFormRouteArgs{key: $key, inspectionId: $inspectionId}';
  }
}

/// generated route for
/// [_i4.InspectionListPage]
class InspectionListRoute extends _i11.PageRouteInfo<void> {
  const InspectionListRoute({List<_i11.PageRouteInfo>? children})
      : super(
          InspectionListRoute.name,
          initialChildren: children,
        );

  static const String name = 'InspectionListRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.InspectionListPage();
    },
  );
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i11.PageRouteInfo<void> {
  const LoginRoute({List<_i11.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginPage();
    },
  );
}

/// generated route for
/// [_i6.NotificationListPage]
class NotificationListRoute extends _i11.PageRouteInfo<void> {
  const NotificationListRoute({List<_i11.PageRouteInfo>? children})
      : super(
          NotificationListRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationListRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.NotificationListPage();
    },
  );
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i11.PageRouteInfo<void> {
  const ProfileRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i7.ProfilePage();
    },
  );
}

/// generated route for
/// [_i8.ReportDetailPage]
class ReportDetailRoute extends _i11.PageRouteInfo<ReportDetailRouteArgs> {
  ReportDetailRoute({
    _i12.Key? key,
    required String reportId,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          ReportDetailRoute.name,
          args: ReportDetailRouteArgs(
            key: key,
            reportId: reportId,
          ),
          rawPathParams: {'id': reportId},
          initialChildren: children,
        );

  static const String name = 'ReportDetailRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ReportDetailRouteArgs>(
          orElse: () =>
              ReportDetailRouteArgs(reportId: pathParams.getString('id')));
      return _i8.ReportDetailPage(
        key: args.key,
        reportId: args.reportId,
      );
    },
  );
}

class ReportDetailRouteArgs {
  const ReportDetailRouteArgs({
    this.key,
    required this.reportId,
  });

  final _i12.Key? key;

  final String reportId;

  @override
  String toString() {
    return 'ReportDetailRouteArgs{key: $key, reportId: $reportId}';
  }
}

/// generated route for
/// [_i9.ReportListPage]
class ReportListRoute extends _i11.PageRouteInfo<void> {
  const ReportListRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ReportListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReportListRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.ReportListPage();
    },
  );
}

/// generated route for
/// [_i10.SplashPage]
class SplashRoute extends _i11.PageRouteInfo<void> {
  const SplashRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.SplashPage();
    },
  );
}
