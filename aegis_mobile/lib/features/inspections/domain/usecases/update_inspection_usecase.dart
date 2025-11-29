import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';
import 'package:aegis_mobile/features/inspections/domain/repositories/inspection_repository.dart';

@lazySingleton
class UpdateInspectionUseCase
    implements UseCase<InspectionEntity, UpdateInspectionParams> {
  final InspectionRepository repository;

  UpdateInspectionUseCase(this.repository);

  @override
  Future<Either<Failure, InspectionEntity>> call(UpdateInspectionParams params) {
    return repository.updateInspection(params.inspection);
  }
}

class UpdateInspectionParams extends Equatable {
  final InspectionEntity inspection;

  const UpdateInspectionParams({required this.inspection});

  @override
  List<Object?> get props => [inspection];
}

