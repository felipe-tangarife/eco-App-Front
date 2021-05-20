part of 'map_bloc.dart';

@immutable
class MapState {
  final bool isReady;
  final bool drawPath;
  final bool followPosition;

  final LatLng centralLocation;

  // Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapState(
      {this.isReady = false,
      this.drawPath = false,
      this.followPosition = false,
      this.centralLocation,
      Map<String, Polyline> polylines,
      Map<String, Marker> markers})
      : this.polylines = polylines ?? new Map(),
        this.markers = markers ?? new Map();

  MapState copyWith(
          {bool isReady,
          bool drawPath,
          bool followPosition,
          LatLng centralLocation,
          Map<String, Polyline> polylines,
          Map<String, Marker> markers}) =>
      MapState(
        isReady: isReady ?? this.isReady,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
        centralLocation: centralLocation ?? this.centralLocation,
        followPosition: followPosition ?? this.followPosition,
        drawPath: drawPath ?? this.drawPath,
      );
}
