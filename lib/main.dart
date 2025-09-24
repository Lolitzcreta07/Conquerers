import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(SmallCityTransitApp());
}

class SmallCityTransitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Punjab E-Bus',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: TransitHomePage(),
    );
  }
}

class TransitHomePage extends StatefulWidget {
  @override
  State<TransitHomePage> createState() => _TransitHomePageState();
}

class _TransitHomePageState extends State<TransitHomePage> {
  LatLng? currentLocation;
  LatLng? destination;
  bool isOffline = false;

  final List<LatLng> routePoints = [
    LatLng(31.6340, 74.8723), // Golden Temple
    LatLng(31.5204, 75.0910), // PAU Gate
  ];


  void _selectLocation(bool isCurrent) async {
    // Simulated location picker – replace with real location logic
    LatLng selected = isCurrent
        ? LatLng(31.6000, 74.8800)
        : LatLng(31.5200, 75.0900);

    setState(() {
      if (isCurrent) {
        currentLocation = selected;
      } else {
        destination = selected;
      }
    });
  }

  void _toggleOffline() {
    setState(() {
      isOffline = !isOffline;
    });
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Emergency'),
        content: Text('Emergency services have been notified. Stay calm.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openMenu(String option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$option selected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punjab E-Bus'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _openMenu,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'E-Ticketing', child: Text('E-Ticketing')),
              PopupMenuItem(value: 'Queries', child: Text('Queries')),
              PopupMenuItem(
                value: 'Offline',
                child: Row(
                  children: [
                    Text('Offline Mode'),
                    Switch(
                      value: isOffline,
                      onChanged: (_) => _toggleOffline(),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Emergency',
                child: Text('Emergency'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.my_location),
                  label: Text('Set Current Location'),
                  onPressed: () => _selectLocation(true),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.flag),
                  label: Text('Set Destination'),
                  onPressed: () => _selectLocation(false),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                
                maxZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smallcitytransit',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4.0,
                      color: Colors.tealAccent,
                    ),
                  ],
                ),
               
                if (destination != null)
                  MarkerLayer(
                    markers: [
                      
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}