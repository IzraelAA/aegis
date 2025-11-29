import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class MarkNotificationReadUseCase implements UseCase<bool, IdParams> {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IdParams params) {
    return repository.markAsRead(params.id);
  }
}

