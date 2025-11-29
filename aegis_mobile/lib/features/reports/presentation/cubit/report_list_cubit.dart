import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/domain/usecases/get_reports_usecase.dart';
import 'package:aegis_mobile/features/reports/domain/usecases/sync_offline_reports_usecase.dart';

@injectable
class ReportListCubit extends BaseCubit<List<ReportEntity>> {
  final GetReportsUseCase getReportsUseCase;
  final SyncOfflineReportsUseCase syncOfflineReportsUseCase;

  ReportListCubit({
    required this.getReportsUseCase,
    required this.syncOfflineReportsUseCase,
  });

  Future<void> loadReports() async {
    emitLoading();

    final result = await getReportsUseCase(const NoParams());

    result.fold(
      (failure) => emitError(failure.message),
      (reports) {
        if (reports.isEmpty) {
          emitEmpty();
        } else {
          emitSuccess(reports);
        }
      },
    );
  }

  Future<void> refresh() async {
    await loadReports();
  }

  Future<int> syncOfflineReports() async {
    final result = await syncOfflineReportsUseCase(const NoParams());
    return result.fold(
      (failure) => 0,
      (count) {
        if (count > 0) {
          loadReports();
        }
        return count;
      },
    );
  }
}

