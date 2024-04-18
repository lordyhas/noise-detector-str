part of 'network_controller_cubit.dart';

enum ConnectionType { wifi, mobile, none }

@immutable
sealed class NetworkState {}

final class NetworkLoading extends NetworkState {}

final class NetworkConnected extends NetworkState {
  final ConnectionType connectionType;
  NetworkConnected({required this.connectionType});
}

final class NetworkDisconnected extends NetworkState {}





