import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/domain/repositories/report_repository.dart';

@lazySingleton
class GetReportByIdUseCase implements UseCase<ReportEntity, IdParams> {
  final ReportRepository repository;

  GetReportByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ReportEntity>> call(IdParams params) {
    return repository.getReportById(params.id);
  }
}

