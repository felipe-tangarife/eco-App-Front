import 'package:eco_app3/bloc/user_location/user_location_bloc.dart';
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
      body: BlocBuilder<UserLocationBloc, UserLocationState>(
        builder: ( _ , state)  => createMap( state )
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        // children: [
        //
        //   BtnUbicacion(),
        //
        // ],
      ),
   );

  }

  Widget createMap(UserLocationState state ) {

    if ( !state.existsLocation ) return Center(child: Text('Ubicando...'));

    // final mapaBloc = BlocProvider.of<MapaBloc>(context);

    final cameraPosition = new CameraPosition(
      target: state.location,
      zoom: 15
    );

    return GoogleMap(
      initialCameraPosition: cameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
    );

  }

}