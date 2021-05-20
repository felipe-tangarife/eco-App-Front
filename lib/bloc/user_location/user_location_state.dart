part of 'user_location_bloc.dart';

@immutable
class UserLocationState {

  final bool following;
  final bool existsLocation;
  final LatLng location;

  UserLocationState({
    this.following = true,
    this.existsLocation = false,
    this.location
  });

  UserLocationState copyWith({
    bool following,
    bool existsLocation,
    LatLng location,
  }) => new UserLocationState(
    following : following ?? this.following,
    existsLocation : existsLocation ?? this.existsLocation,
    location : location ?? this.location,
  );
  

}
