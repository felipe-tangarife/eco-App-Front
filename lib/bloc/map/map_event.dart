part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapReady extends MapEvent{}

class OnMarkPath extends MapEvent{}

class OnFollowLocation extends MapEvent{}

class OnCreateRouteStartDestination extends MapEvent{

  final List<LatLng> coords;
  final double distance;
  final double duration;
  final String destinationName;

  OnCreateRouteStartDestination( this.coords, this.distance, this.duration, this.destinationName );

}

class OnMovedMap extends MapEvent{
  final LatLng centralMap;
  OnMovedMap(this.centralMap);

}

class OnNewLocation extends MapEvent{
  final LatLng location;
  OnNewLocation(this.location);

}
