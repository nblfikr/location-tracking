import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:maps/bloc/location_event.dart';
import 'package:maps/bloc/location_state.dart';
import 'package:maps/services/location.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted = PermissionStatus.denied;

  LocationBloc() : super(PermissionDenied()) {
    on<AskServicePermission>(_askForPermission);
    on<OnInitial>(_onInitial);
    on<OnStartWalk>(_onStartWalk);
    on<OnWalk>(_onWalk);
  }

  Future<void> _askForPermission(
      AskServicePermission event, Emitter<LocationState> emit) async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _onInitial(OnInitial event, Emitter<LocationState> emit) async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        _permissionGranted = PermissionStatus.denied;
        emit(PermissionDenied());
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        emit(PermissionDenied());
        return;
      }
    }

    if (_permissionGranted == PermissionStatus.granted) {
      final LocationData coordinates = await _location.getLocation();

      UserLocation userLocation = UserLocation(
          coordinates.latitude ?? UserLocation().latitude,
          coordinates.longitude ?? UserLocation().longitude);
      emit(InitialCoordinates(userLocation));
    } else {
      emit(PermissionDenied());
    }
  }

  Future<void> _onStartWalk(
      OnStartWalk event, Emitter<LocationState> emit) async {
    if (_permissionGranted == PermissionStatus.granted) {
      _location.onLocationChanged.listen((location) {
        add(OnWalk(
            UserLocation(location.latitude ?? 0, location.longitude ?? 0)));
      });
    } else {
      emit(PermissionDenied());
    }
  }

  Future<void> _onWalk(OnWalk event, Emitter<LocationState> emit) async {
    emit(WalkCoordinates(event.location));
  }
}
