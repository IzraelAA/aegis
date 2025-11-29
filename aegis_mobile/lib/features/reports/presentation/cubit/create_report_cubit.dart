import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/domain/usecases/create_report_usecase.dart';

@injectable
class CreateReportCubit extends BaseCubit<ReportEntity> {
  final CreateReportUseCase createReportUseCase;

  CreateReportCubit({
    required this.createReportUseCase,
  });

  Future<void> createReport(ReportEntity report) async {
    emitLoading();

    final result = await createReportUseCase(CreateReportParams(report: report));

    result.fold(
      (failure) => emitError(failure.message),
      (createdReport) => emitSuccess(createdReport),
    );
  }
}

