import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/reports/domain/repositories/report_repository.dart';

@lazySingleton
class SyncOfflineReportsUseCase implements UseCase<int, NoParams> {
  final ReportRepository repository;

  SyncOfflineReportsUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.syncOfflineQueue();
  }
}

