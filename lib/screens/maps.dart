import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps/bloc/location_bloc.dart';
import 'package:maps/bloc/location_state.dart';
import 'package:maps/services/location.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  UserLocation userLocation = UserLocation();
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          center: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: 16.0,
          maxZoom: 19.0),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        // PolylineLayer(
        //   polylineCulling: false,
        //   polylines: [
        //     Polyline(points: [
        //       LatLng(-7.586295, 110.219545),
        //       LatLng(-7.589018, 110.219630),
        //       LatLng(-7.589380, 110.219684),
        //       LatLng(-7.592283, 110.220403),
        //       LatLng(-7.597430, 110.222366),
        //       LatLng(-7.593559, 110.219319)
        //     ], color: Colors.blue, strokeWidth: 5.0),
        //   ],
        // ),
        BlocBuilder<LocationBloc, LocationState>(builder: (context, state) {
          // if (state is WalkCoordinates) {
          return MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                    (state is WalkCoordinates)
                        ? state.location.latitude
                        : (state is InitialCoordinates)
                            ? state.initial.latitude
                            : UserLocation().latitude,
                    (state is WalkCoordinates)
                        ? state.location.longitude
                        : (state is InitialCoordinates)
                            ? state.initial.longitude
                            : UserLocation().longitude),
                width: 80,
                height: 80,
                builder: (_) => const Icon(
                  Icons.my_location_rounded,
                  color: Colors.amber,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
