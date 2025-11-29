import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';
import 'package:aegis_mobile/features/inspections/domain/usecases/get_inspections_usecase.dart';

@injectable
class InspectionListCubit extends BaseCubit<List<InspectionEntity>> {
  final GetInspectionsUseCase getInspectionsUseCase;

  InspectionListCubit({
    required this.getInspectionsUseCase,
  });

  Future<void> loadInspections() async {
    emitLoading();

    final result = await getInspectionsUseCase(const NoParams());

    result.fold(
      (failure) => emitError(failure.message),
      (inspections) {
        if (inspections.isEmpty) {
          emitEmpty();
        } else {
          emitSuccess(inspections);
        }
      },
    );
  }

  Future<void> refresh() async {
    await loadInspections();
  }
}

