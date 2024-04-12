import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Colors.dart';

class HospitalLocationPage extends StatefulWidget {
  final LatLng hospitalLocation;
  final String hospitalName;
  final LatLng currentPosition;

  HospitalLocationPage({
    required this.hospitalLocation,
    required this.hospitalName,
    required this.currentPosition,
  });

  @override
  State<HospitalLocationPage> createState() => _HospitalLocationPageState();
}

class _HospitalLocationPageState extends State<HospitalLocationPage> {
  Set<Polyline> myPolylines = {};
  BitmapDescriptor customMarkerPerson = BitmapDescriptor.defaultMarker;
  getCustomMarkerPerson() async {
    customMarkerPerson = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'Assets/Images/per.png',
    );
    setState(() {});
  }

  Set<Polygon> myPolygon() {
    List<LatLng> polygonCoords = [];
    polygonCoords.add(LatLng(widget.currentPosition.latitude - 0.5,
        widget.currentPosition.longitude - 0.5));
    polygonCoords.add(LatLng(widget.currentPosition.latitude - 1,
        widget.currentPosition.longitude + 0.5));
    // polygonCoords.add(LatLng(widget.currentPosition.latitude + 0.1,
    //     widget.currentPosition.latitude - 0.1));

    // polygonCoords.add(LatLng(widget.currentPosition.latitude + 0.1,
    //     widget.currentPosition.latitude + 0.1));

    polygonCoords.add(LatLng(widget.hospitalLocation.latitude + 0.5,
        widget.hospitalLocation.longitude + 0.5));
    polygonCoords.add(LatLng(widget.currentPosition.latitude + 0.5,
        widget.currentPosition.longitude - 0.5));

    // polygonCoords.add(LatLng(widget.hospitalLocation.latitude + 0.1,
    //     widget.hospitalLocation.latitude - 0.1));

    // polygonCoords.add(LatLng(widget.hospitalLocation.latitude - 0.1,
    //     widget.hospitalLocation.latitude + 0.1));
    Set<Polygon> polygonSet = {};
    polygonSet.add(Polygon(
        polygonId: PolygonId('value'),
        points: polygonCoords,
        strokeColor: background,
        strokeWidth: 3,
        fillColor: Colors.transparent));
    return polygonSet;
  }

  createCurvedPolyline() {
    final double totalPoints = 100;
    final List<LatLng> points = [];
    for (int i = 0; i < totalPoints; i++) {
      double t = i / (totalPoints - 1);
      double lat = (1 - t) * widget.currentPosition.latitude +
          t * widget.hospitalLocation.latitude;
      double lng = (1 - t) * widget.currentPosition.longitude +
          t * widget.hospitalLocation.longitude;
      points.add(LatLng(lat, lng));
    }
    myPolylines.add(Polyline(
      polylineId: PolylineId('1'),
      color: background,
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      points: points,
      width: 3,
    ));
  }

  @override
  void initState() {
    getCustomMarkerPerson();
    super.initState();
    createCurvedPolyline();
  }

  @override
  Widget build(BuildContext context) {
    double dis = Geolocator.distanceBetween(
            widget.hospitalLocation.latitude,
            widget.hospitalLocation.longitude,
            widget.currentPosition.latitude,
            widget.currentPosition.longitude) /
        1000;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: background,
          title: Text(
            widget.hospitalName,
            style: TextStyle(color: Colors.white),
          )
//        actions: [Icon(Icons.hospital)],
          ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.hospitalLocation,
          zoom: 12,
        ),
        // polygons: myPolygon(),
        // polylines: myPolylines,
        markers: {
          Marker(
            markerId: MarkerId('hospitalMarker'),
            infoWindow: InfoWindow(
              title: widget.hospitalName,
              snippet: "${double.parse((dis).toStringAsFixed(2))} Km",
            ),
            visible: true,
            draggable: false,
            flat: false,
            position: widget.hospitalLocation,
            icon: BitmapDescriptor.defaultMarker,
            consumeTapEvents: false,
          ),
        },
      ),
    );
  }
}
