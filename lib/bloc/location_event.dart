import 'package:equatable/equatable.dart';
import 'package:maps/services/location.dart';

abstract class LocationEvent extends Equatable {}

class AskServicePermission extends LocationEvent {
  @override
  List<Object?> get props => [];
}

class OnInitial extends LocationEvent {
  @override
  List<Object?> get props => [];
}

class OnStartWalk extends LocationEvent {
  @override
  List<Object?> get props => [];
}

class OnWalk extends LocationEvent {
  final UserLocation location;
  OnWalk(this.location);

  @override
  List<Object?> get props => [location];
}
