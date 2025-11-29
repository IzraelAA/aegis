import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aegis_mobile/core/state_management/base_state.dart';

abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(const BaseState.initial());

  void emitLoading() => emit(const BaseState.loading());

  void emitSuccess(T data) => emit(BaseState.success(data));

  void emitError(String message) => emit(BaseState.error(message));

  void emitEmpty() => emit(const BaseState.empty());

  void reset() => emit(const BaseState.initial());
}
