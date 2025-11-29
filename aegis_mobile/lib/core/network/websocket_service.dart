import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:aegis_mobile/core/local_storage/hive_storage.dart';

/// WebSocket event types
enum WebSocketEventType {
  alert,
  notification,
  reportUpdate,
  inspectionUpdate,
  connected,
  disconnected,
  error,
}

/// WebSocket message model
class WebSocketMessage {
  final WebSocketEventType type;
  final Map<String, dynamic>? data;
  final String? error;
  final DateTime timestamp;

  WebSocketMessage({
    required this.type,
    this.data,
    this.error,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: _parseEventType(json['type'] as String?),
      data: json['data'] as Map<String, dynamic>?,
      error: json['error'] as String?,
    );
  }

  static WebSocketEventType _parseEventType(String? type) {
    switch (type?.toLowerCase()) {
      case 'alert':
        return WebSocketEventType.alert;
      case 'notification':
        return WebSocketEventType.notification;
      case 'report_update':
        return WebSocketEventType.reportUpdate;
      case 'inspection_update':
        return WebSocketEventType.inspectionUpdate;
      default:
        return WebSocketEventType.notification;
    }
  }
}

/// WebSocket service for real-time communication
@lazySingleton
class WebSocketService {
  static const String _wsUrl = 'wss://api.example.com/ws';
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const int _maxReconnectAttempts = 5;

  final HiveStorage _storage;
  
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  
  int _reconnectAttempts = 0;
  bool _isConnected = false;
  bool _shouldReconnect = true;

  final _messageController = StreamController<WebSocketMessage>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  WebSocketService(this._storage);

  /// Stream of incoming WebSocket messages
  Stream<WebSocketMessage> get messages => _messageController.stream;

  /// Stream of connection status changes
  Stream<bool> get connectionStatus => _connectionController.stream;

  /// Current connection status
  bool get isConnected => _isConnected;

  /// Connect to WebSocket server
  Future<void> connect() async {
    if (_isConnected) return;

    try {
      final token = _storage.getToken();
      final uri = Uri.parse('$_wsUrl?token=$token');
      
      _channel = WebSocketChannel.connect(uri);
      
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionController.add(true);
      _messageController.add(WebSocketMessage(type: WebSocketEventType.connected));

      // Start ping timer to keep connection alive
      _startPingTimer();
    } catch (e) {
      _onError(e);
    }
  }

  /// Disconnect from WebSocket server
  Future<void> disconnect() async {
    _shouldReconnect = false;
    _stopTimers();
    
    await _subscription?.cancel();
    await _channel?.sink.close();
    
    _isConnected = false;
    _connectionController.add(false);
    _messageController.add(WebSocketMessage(type: WebSocketEventType.disconnected));
  }

  /// Send message through WebSocket
  void send(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(json.encode(message));
    }
  }

  /// Subscribe to specific event type
  Stream<WebSocketMessage> on(WebSocketEventType type) {
    return messages.where((msg) => msg.type == type);
  }

  void _onMessage(dynamic message) {
    try {
      final data = json.decode(message as String) as Map<String, dynamic>;
      final wsMessage = WebSocketMessage.fromJson(data);
      _messageController.add(wsMessage);
    } catch (e) {
      _messageController.add(WebSocketMessage(
        type: WebSocketEventType.error,
        error: 'Failed to parse message: $e',
      ));
    }
  }

  void _onError(dynamic error) {
    _messageController.add(WebSocketMessage(
      type: WebSocketEventType.error,
      error: error.toString(),
    ));
    _handleDisconnect();
  }

  void _onDone() {
    _handleDisconnect();
  }

  void _handleDisconnect() {
    _isConnected = false;
    _connectionController.add(false);
    _stopTimers();
    
    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _messageController.add(WebSocketMessage(
        type: WebSocketEventType.error,
        error: 'Max reconnection attempts reached',
      ));
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      _reconnectAttempts++;
      connect();
    });
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      send({'type': 'ping'});
    });
  }

  void _stopTimers() {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
  }

  /// Dispose resources
  void dispose() {
    _shouldReconnect = false;
    _stopTimers();
    disconnect();
    _messageController.close();
    _connectionController.close();
  }
}

