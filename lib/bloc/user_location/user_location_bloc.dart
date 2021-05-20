import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'user_location_event.dart';
part 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {

  UserLocationBloc() : super(UserLocationState());

  StreamSubscription<Position> _positionSubscription;


  void startFollow() {


    _positionSubscription = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high, distanceFilter: 10).listen(( Position position ) {
      final newPosition = new LatLng(position.latitude, position.longitude);
      add( OnPositionChange( newPosition ) );
    });

  }

  void cancelFollow() {
    _positionSubscription?.cancel();
  }


  @override
  Stream<UserLocationState> mapEventToState( UserLocationEvent event ) async* {
    
    if ( event is OnPositionChange ) {
      yield state.copyWith(
        existsLocation: true,
        location: event.position
      );
    }

  }
}
