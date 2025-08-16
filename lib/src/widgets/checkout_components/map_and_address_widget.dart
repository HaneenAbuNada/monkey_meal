import 'package:flutter/material.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_search_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ChangeAddressScreen extends StatelessWidget {
  const ChangeAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Change Address', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: MapWidget()),
          SizedBox(height: 16),
          CustomSearchBar(hintText: 'Search Address'),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: LatLng(30.739923, 31.584841), initialZoom: 18.6),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.monkey_meal_project',
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
    );
  }
}
