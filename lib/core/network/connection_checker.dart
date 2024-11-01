import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// An abstract interface for checking internet connection.
abstract interface class ConnectionChecker {
  /// Returns a [Future] that resolves to a boolean value indicating whether the device is connected to the internet.
  Future<bool> get isConnected;
}

/// A concrete implementation of the [ConnectionChecker] interface.
class ConnectionCheckerImpl implements ConnectionChecker {
  /// Creates a new instance of [ConnectionCheckerImpl] with the specified [internetConnection].
  ConnectionCheckerImpl(this.internetConnection);

  final InternetConnection internetConnection;

  @override
  Future<bool> get isConnected => internetConnection.hasInternetAccess;
}
