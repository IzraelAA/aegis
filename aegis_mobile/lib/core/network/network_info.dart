abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // You can use connectivity_plus package for actual implementation
    // For now, we'll return true as placeholder
    return true;
  }
}

