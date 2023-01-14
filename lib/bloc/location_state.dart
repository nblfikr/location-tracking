import 'package:equatable/equatable.dart';
import 'package:maps/services/location.dart';

abstract class LocationState extends Equatable {}

class PermissionDenied extends LocationState {
  final String message = "aplikasi tidak dapat menggunakan lokasi";

  PermissionDenied();

  @override
  List<Object?> get props => [message];
}

class Loading extends LocationState {
  @override
  List<Object?> get props => [];
}

class InitialCoordinates extends LocationState {
  final UserLocation initial;

  InitialCoordinates(this.initial);

  @override
  List<Object?> get props => [initial];
}

class WalkCoordinates extends LocationState {
  final UserLocation location;

  WalkCoordinates(this.location);

  @override
  List<Object?> get props => [location];
}
