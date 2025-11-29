import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/domain/repositories/report_repository.dart';

@lazySingleton
class CreateReportUseCase implements UseCase<ReportEntity, CreateReportParams> {
  final ReportRepository repository;

  CreateReportUseCase(this.repository);

  @override
  Future<Either<Failure, ReportEntity>> call(CreateReportParams params) {
    return repository.createReport(params.report);
  }
}

class CreateReportParams extends Equatable {
  final ReportEntity report;

  const CreateReportParams({required this.report});

  @override
  List<Object?> get props => [report];
}

