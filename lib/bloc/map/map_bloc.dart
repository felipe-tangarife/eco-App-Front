import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:eco_app3/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:eco_app3/themes/map_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState());

  GoogleMapController _mapController;

  // Polylines
  Polyline _myRoute = new Polyline(
    polylineId: PolylineId('my_route'),
    width: 4,
    color: Colors.transparent,
  );

  Polyline _myRouteDestination = new Polyline(
    polylineId: PolylineId('my_route_destination'),
    width: 4,
    color: Colors.black87,
  );

  void initMap(GoogleMapController controller) {
    if (!state.isReady) {
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(mapTheme));

      add(OnMapReady());
    }
  }

  void moveCamera(LatLng destination) {
    final cameraUpdate = CameraUpdate.newLatLng(destination);
    print(cameraUpdate);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is OnMapReady) {
      yield state.copyWith(isReady: true);
    } else if (event is OnNewLocation) {
      yield* this._onNewLocation(event);
    } else if (event is OnMarkPath) {
      yield* this._onMarkPath(event);
    } else if (event is OnFollowLocation) {
      yield* this._onFollowLocation(event);
    } else if (event is OnMovedMap) {
      yield state.copyWith(centralLocation: event.centralMap);
    } else if (event is OnCreateRouteStartDestination) {
      yield* _onCreateRouteStartDestination(event);
    }
  }

  Stream<MapState> _onNewLocation( OnNewLocation event ) async* {

    if ( state.followPosition ) {
      this.moveCamera( event.location );
    }


    final points = [ ...this._myRoute.points, event.location ];
    this._myRoute = this._myRoute.copyWith( pointsParam: points );

    final currentPolylines = state.polylines;
    currentPolylines['my_route'] = this._myRoute;

    yield state.copyWith( polylines: currentPolylines );

  }

  Stream<MapState> _onMarkPath( OnMarkPath event ) async* {

    if ( !state.drawPath ) {
      this._myRoute = this._myRoute.copyWith( colorParam: Colors.black87 );
    } else {
      this._myRoute = this._myRoute.copyWith( colorParam: Colors.transparent );
    }

    final currentPolylines = state.polylines;
    currentPolylines['my_route'] = this._myRoute;

    yield state.copyWith(
        drawPath: !state.drawPath,
        polylines: currentPolylines
    );

  }

  Stream<MapState> _onFollowLocation( OnFollowLocation event ) async* {

    if ( !state.followPosition ) {
      this.moveCamera( this._myRoute.points[ this._myRoute.points.length - 1 ] );
    }
    yield state.copyWith( followPosition: !state.followPosition );
  }

  Stream<MapState> _onCreateRouteStartDestination( OnCreateRouteStartDestination event ) async* {

    this._myRouteDestination = this._myRouteDestination.copyWith(
        pointsParam: event.coords
    );

    final currentPolylines = state.polylines;
    currentPolylines['my_route_destination'] = this._myRouteDestination;

    // Icono inicio
    final iconStart  = await getMarkerStartIcon( event.duration.toInt() );

    final iconDestination = await getMarkerDestinationIcon(event.destinationName, event.distance);

    // Marcadores
    final markerStart= new Marker(
        anchor: Offset(0.0,0.5),
        markerId: MarkerId('startM'),
        position: event.coords[0],
        infoWindow: InfoWindow(
          title: 'Mi Ubicación',
          snippet: 'Duración recorrido: ${ (event.duration / 60).floor() } minutos',
        )
    );

    double kms = event.distance / 1000;
    kms = (kms * 100).floor().toDouble();
    kms = kms / 100;

    final markerDestination = new Marker(
        markerId: MarkerId('destM'),
        position: event.coords[ event.coords.length - 1 ],
        anchor: Offset(0.0,0.5),
        infoWindow: InfoWindow(
          title: event.destinationName,
          snippet: 'Distancia: $kms Km, duración recorrido:  ${ (event.duration / 60).floor()} minutos',
        )
    );

    final newMarkers = { ...state.markers };
    newMarkers['startM']  = markerStart;
    newMarkers['destM'] = markerDestination;

    // Future.delayed(Duration(milliseconds: 300)).then(
    //         (value) {
    //       // _mapController.showMarkerInfoWindow(MarkerId('startM'));
    //       // _mapController.showMarkerInfoWindow(MarkerId('destM'));
    //     }
    // );


    yield state.copyWith(
        polylines: currentPolylines,
        markers: newMarkers
    );
  }
}
