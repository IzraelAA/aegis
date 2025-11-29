import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/domain/usecases/get_report_by_id_usecase.dart';

@injectable
class ReportDetailCubit extends BaseCubit<ReportEntity> {
  final GetReportByIdUseCase getReportByIdUseCase;

  ReportDetailCubit({
    required this.getReportByIdUseCase,
  });

  Future<void> loadReport(String id) async {
    emitLoading();

    final result = await getReportByIdUseCase(IdParams(id: id));

    result.fold(
      (failure) => emitError(failure.message),
      (report) => emitSuccess(report),
    );
  }
}

