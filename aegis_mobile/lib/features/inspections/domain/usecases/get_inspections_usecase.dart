import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';
import 'package:aegis_mobile/features/inspections/domain/repositories/inspection_repository.dart';

@lazySingleton
class GetInspectionsUseCase implements UseCase<List<InspectionEntity>, NoParams> {
  final InspectionRepository repository;

  GetInspectionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InspectionEntity>>> call(NoParams params) {
    return repository.getInspections();
  }
}

