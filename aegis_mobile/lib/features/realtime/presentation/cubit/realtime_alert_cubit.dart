import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/network/websocket_service.dart';

/// State for real-time alerts
class RealTimeAlertState {
  final bool isConnected;
  final List<WebSocketMessage> alerts;
  final String? lastError;

  const RealTimeAlertState({
    this.isConnected = false,
    this.alerts = const [],
    this.lastError,
  });

  RealTimeAlertState copyWith({
    bool? isConnected,
    List<WebSocketMessage>? alerts,
    String? lastError,
  }) {
    return RealTimeAlertState(
      isConnected: isConnected ?? this.isConnected,
      alerts: alerts ?? this.alerts,
      lastError: lastError,
    );
  }
}

/// Cubit for handling real-time alerts via WebSocket
@injectable
class RealTimeAlertCubit extends Cubit<RealTimeAlertState> {
  final WebSocketService _webSocketService;
  
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionSubscription;

  RealTimeAlertCubit(this._webSocketService)
      : super(const RealTimeAlertState()) {
    _subscribeToWebSocket();
  }

  void _subscribeToWebSocket() {
    // Listen for connection status changes
    _connectionSubscription = _webSocketService.connectionStatus.listen(
      (isConnected) {
        emit(state.copyWith(isConnected: isConnected));
      },
    );

    // Listen for alert messages
    _messageSubscription = _webSocketService.on(WebSocketEventType.alert).listen(
      (message) {
        final updatedAlerts = [...state.alerts, message];
        emit(state.copyWith(alerts: updatedAlerts));
      },
    );

    // Listen for errors
    _webSocketService.on(WebSocketEventType.error).listen(
      (message) {
        emit(state.copyWith(lastError: message.error));
      },
    );
  }

  /// Connect to WebSocket server
  Future<void> connect() async {
    await _webSocketService.connect();
  }

  /// Disconnect from WebSocket server
  Future<void> disconnect() async {
    await _webSocketService.disconnect();
  }

  /// Clear all alerts
  void clearAlerts() {
    emit(state.copyWith(alerts: []));
  }

  /// Mark alert as read
  void markAlertAsRead(int index) {
    if (index < 0 || index >= state.alerts.length) return;
    // Alerts are immutable, so we just track which ones are read in the UI
  }

  /// Send acknowledgment for an alert
  void acknowledgeAlert(String alertId) {
    _webSocketService.send({
      'type': 'acknowledge_alert',
      'alert_id': alertId,
    });
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    return super.close();
  }
}

