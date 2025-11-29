import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/sample/domain/entities/sample_entity.dart';
import 'package:aegis_mobile/features/sample/domain/usecases/get_samples_usecase.dart';
import 'package:aegis_mobile/features/sample/domain/usecases/get_sample_by_id_usecase.dart';

@injectable
class SampleCubit extends BaseCubit<List<SampleEntity>> {
  final GetSamplesUseCase getSamplesUseCase;
  final GetSampleByIdUseCase getSampleByIdUseCase;

  SampleCubit({
    required this.getSamplesUseCase,
    required this.getSampleByIdUseCase,
  });

  Future<void> loadSamples() async {
    emitLoading();

    final result = await getSamplesUseCase(const NoParams());

    result.fold(
      (failure) => emitError(failure.message),
      (samples) {
        if (samples.isEmpty) {
          emitEmpty();
        } else {
          emitSuccess(samples);
        }
      },
    );
  }

  Future<void> refresh() async {
    await loadSamples();
  }
}

