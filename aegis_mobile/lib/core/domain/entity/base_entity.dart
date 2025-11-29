import 'package:equatable/equatable.dart';

/// Base class for all domain entities
/// Entities should be immutable and represent business logic objects
abstract class BaseEntity extends Equatable {
  const BaseEntity();

  @override
  bool get stringify => true;
}

