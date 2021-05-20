part of 'user_location_bloc.dart';

@immutable
abstract class UserLocationEvent {}

class OnPositionChange extends UserLocationEvent {

  final LatLng position;
  OnPositionChange(this.position);

}
