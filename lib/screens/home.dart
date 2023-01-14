import 'package:flutter/material.dart';
import 'package:maps/screens/maps.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentActiveTab = 0;

  static const List<Widget> _widgetOptions = <Widget>[MapsScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _currentActiveTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_currentActiveTab),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.location_pin), label: 'Maps'),
          BottomNavigationBarItem(icon: Icon(Icons.stream), label: 'Stream')
        ],
        currentIndex: _currentActiveTab,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
