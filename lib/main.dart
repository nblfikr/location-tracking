import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/bloc/location_bloc.dart';
import 'package:maps/bloc/location_event.dart';
import 'package:maps/bloc/location_state.dart';

import 'screens/maps.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => LocationBloc()..add(OnInitial()),
      child: Builder(
        builder: (context) => Scaffold(
          body: const MapsScreen(),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                BlocProvider.of<LocationBloc>(context).add(OnStartWalk()),
            // onPressed: () => context.read<LocationBloc>().add(OnStartWalk()),
            child: const Icon(Icons.rocket_launch),
          ),
        ),
      ),
    ));
  }
}

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is PermissionDenied) {
            // ignore: todo
            // TODO:: notif permisison denied using snackbar
            // return SnackBar(content: Text(state.message));

            return Center(child: Text(state.message));
          }
          if (state is Loading) {
            return const Center(
              child: Text("loading..."),
            );
          }
          if (state is InitialCoordinates) {
            return Center(
                child: Text(
                    '${state.initial.latitude}, ${state.initial.longitude}'));
          }
          if (state is WalkCoordinates) {
            return Center(
                child: Text(
                    '${state.location.latitude}, ${state.location.longitude}'));
          }

          return const Center(
            child: Text("Location not set"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<LocationBloc>().add(OnStartWalk()),
        child: const Icon(Icons.rocket_launch),
      ),
    );
  }
}
