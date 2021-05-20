import 'package:eco_app3/bloc/map/map_bloc.dart';
import 'package:eco_app3/bloc/user_location/user_location_bloc.dart';
import 'package:eco_app3/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  @override
  void initState() {
    
    context.read<UserLocationBloc>().startFollow();

    super.initState();
  }

  @override
  void dispose() {
    context.read<UserLocationBloc>().cancelFollow();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          BlocBuilder<UserLocationBloc, UserLocationState>(
              builder: ( _ , state)  => createMap( state )
          ),

          Positioned(
              top: 15,
              child: SearchBar()
          ),

          ManualMark(),

        ],
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          BtnLocation(),
          BtnFollowLocation(),
          BtnMyRoute()

        ],
      ),
   );

  }

  Widget createMap(UserLocationState state ) {

    if ( !state.existsLocation ) return Center(child: Text('Ubicando...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.add( OnNewLocation( state.location ) );
    final cameraPosition = new CameraPosition(
      target: state.location,
      zoom: 15
    );

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, _ ) {
        return GoogleMap(
          initialCameraPosition: cameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: mapBloc.initMap,
          polylines: mapBloc.state.polylines.values.toSet(),
          markers: mapBloc.state.markers.values.toSet(),
          onCameraMove: ( cameraPosition ) {
            // cameraPosition.target = LatLng central del mapa
            mapBloc.add( OnMovedMap( cameraPosition.target ));
          },
        );
      },
    );




  }

}