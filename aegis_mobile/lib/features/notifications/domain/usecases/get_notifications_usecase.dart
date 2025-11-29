import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/notifications/domain/entities/notification_entity.dart';
import 'package:aegis_mobile/features/notifications/domain/repositories/notification_repository.dart';

@lazySingleton
class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) {
    return repository.getNotifications();
  }
}

