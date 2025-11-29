import 'package:equatable/equatable.dart';
import 'package:aegis_mobile/utils/app_status.dart';

class BaseState<T> extends Equatable {
  final AppStatus status;
  final T? data;
  final String? errorMessage;

  const BaseState._({
    required this.status,
    this.data,
    this.errorMessage,
  });

  const BaseState.initial() : this._(status: AppStatus.initial);

  const BaseState.loading() : this._(status: AppStatus.loading);

  const BaseState.success(T data)
      : this._(status: AppStatus.success, data: data);

  const BaseState.error(String message)
      : this._(status: AppStatus.error, errorMessage: message);

  const BaseState.empty() : this._(status: AppStatus.empty);

  bool get isInitial => status == AppStatus.initial;
  bool get isLoading => status == AppStatus.loading;
  bool get isSuccess => status == AppStatus.success;
  bool get isError => status == AppStatus.error;
  bool get isEmpty => status == AppStatus.empty;

  BaseState<T> copyWith({
    AppStatus? status,
    T? data,
    String? errorMessage,
  }) {
    return BaseState._(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}
