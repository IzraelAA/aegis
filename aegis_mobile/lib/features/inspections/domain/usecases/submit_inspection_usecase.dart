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
  Future<Either<Failure, InspectionEntity>> call(SubmitInspectionParams params) {
    return repository.submitInspection(params.inspection);
  }
}

class SubmitInspectionParams extends Equatable {
  final InspectionEntity inspection;

  const SubmitInspectionParams({required this.inspection});

  @override
  List<Object?> get props => [inspection];
}

