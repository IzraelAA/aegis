/// Enum representing the various states of data/UI operations
enum AppStatus {
  /// Initial state before any operation
  initial,

  /// Loading state during async operations
  loading,

  /// Success state when operation completes successfully
  success,

  /// Error state when operation fails
  error,

  /// Empty state when no data is available
  empty,

  /// Refreshing state for pull-to-refresh operations
  refreshing,

  /// Loading more state for pagination
  loadingMore,
}

/// Extension to provide convenience methods for AppStatus
extension AppStatusExtension on AppStatus {
  bool get isInitial => this == AppStatus.initial;
  bool get isLoading => this == AppStatus.loading;
  bool get isSuccess => this == AppStatus.success;
  bool get isError => this == AppStatus.error;
  bool get isEmpty => this == AppStatus.empty;
  bool get isRefreshing => this == AppStatus.refreshing;
  bool get isLoadingMore => this == AppStatus.loadingMore;

  /// Returns true if the status indicates data is being fetched
  bool get isFetching => isLoading || isRefreshing || isLoadingMore;

  /// Returns true if the status is in a terminal state
  bool get isTerminal => isSuccess || isError || isEmpty;
}

/// Enum for form submission status
enum FormStatus {
  initial,
  submitting,
  success,
  failure,
}

extension FormStatusExtension on FormStatus {
  bool get isInitial => this == FormStatus.initial;
  bool get isSubmitting => this == FormStatus.submitting;
  bool get isSuccess => this == FormStatus.success;
  bool get isFailure => this == FormStatus.failure;
}

/// Enum for authentication status
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

extension AuthStatusExtension on AuthStatus {
  bool get isUnknown => this == AuthStatus.unknown;
  bool get isAuthenticated => this == AuthStatus.authenticated;
  bool get isUnauthenticated => this == AuthStatus.unauthenticated;
}

