import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';
import 'package:aegis_mobile/features/inspections/domain/usecases/update_inspection_usecase.dart';
import 'package:aegis_mobile/features/inspections/domain/usecases/submit_inspection_usecase.dart';

@injectable
class InspectionFormCubit extends BaseCubit<InspectionEntity> {
  final UpdateInspectionUseCase updateInspectionUseCase;
  final SubmitInspectionUseCase submitInspectionUseCase;

  InspectionFormCubit({
    required this.updateInspectionUseCase,
    required this.submitInspectionUseCase,
  });

  InspectionEntity? _currentInspection;

  void setInspection(InspectionEntity inspection) {
    _currentInspection = inspection;
    emitSuccess(inspection);
  }

  Future<void> updateChecklistItem(
    String itemId, {
    bool? isCompliant,
    String? notes,
    List<String>? photoUrls,
  }) async {
    if (_currentInspection == null) return;

    final updatedItems = _currentInspection!.checklistItems.map((item) {
      if (item.id == itemId) {
        return item.copyWith(
          isCompliant: isCompliant ?? item.isCompliant,
          notes: notes ?? item.notes,
          photoUrls: photoUrls ?? item.photoUrls,
        );
      }
      return item;
    }).toList();

    _currentInspection = _currentInspection!.copyWith(
      checklistItems: updatedItems,
      status: InspectionStatus.inProgress,
    );

    // Auto-save
    await _saveProgress();
    emitSuccess(_currentInspection!);
  }

  Future<void> _saveProgress() async {
    if (_currentInspection == null) return;

    await updateInspectionUseCase(
      UpdateInspectionParams(inspection: _currentInspection!),
    );
  }

  Future<void> submitInspection({String? signature, String? notes}) async {
    if (_currentInspection == null) return;

    emitLoading();

    // First update the inspection with signature and notes
    _currentInspection = _currentInspection!.copyWith(
      signature: signature,
      notes: notes,
    );
    await _saveProgress();

    // Then submit by updating status to completed
    final result = await submitInspectionUseCase(
      SubmitInspectionParams(inspectionId: _currentInspection!.id),
    );

    result.fold(
      (failure) => emitError(failure.message),
      (inspection) {
        _currentInspection = inspection;
        emitSuccess(inspection);
      },
    );
  }

  bool get isComplete {
    if (_currentInspection == null) return false;
    return _currentInspection!.checklistItems
        .every((item) => item.isCompliant != null);
  }

  double get progress {
    if (_currentInspection == null) return 0;
    return _currentInspection!.completionPercentage;
  }
}

