/// Base class for all data models
/// Models should handle JSON serialization/deserialization
abstract class BaseModel<E> {
  /// Convert model to JSON
  Map<String, dynamic> toJson();

  /// Convert model to domain entity
  E toEntity();
}

/// Base class for models that can be created from JSON
abstract class FromJsonModel<T> {
  static T fromJson<T>(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson must be implemented');
  }
}

