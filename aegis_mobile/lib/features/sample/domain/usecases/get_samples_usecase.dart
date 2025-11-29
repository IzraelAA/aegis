import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/sample/domain/entities/sample_entity.dart';
import 'package:aegis_mobile/features/sample/domain/repositories/sample_repository.dart';

@lazySingleton
class GetSamplesUseCase implements UseCase<List<SampleEntity>, NoParams> {
  final SampleRepository repository;

  GetSamplesUseCase(this.repository);

  @override
  Future<Either<Failure, List<SampleEntity>>> call(NoParams params) {
    return repository.getSamples();
  }
}

