import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';
import 'package:aegis_mobile/features/inspections/domain/repositories/inspection_repository.dart';

@lazySingleton
class SubmitInspectionUseCase
    implements UseCase<InspectionEntity, SubmitInspectionParams> {
  final InspectionRepository repository;

  SubmitInspectionUseCase(this.repository);

  @override
  Future<Either<Failure, InspectionEntity>> call(
      SubmitInspectionParams params) {
    // Submit inspection by updating its status to 'completed'
    return repository.updateInspectionStatus(params.inspectionId, 'completed');
  }
}

class SubmitInspectionParams extends Equatable {
  final String inspectionId;

  const SubmitInspectionParams({required this.inspectionId});

  @override
  List<Object?> get props => [inspectionId];
}
