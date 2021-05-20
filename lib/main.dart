import 'package:eco_app3/bloc/user_location/user_location_bloc.dart';
import 'package:eco_app3/views/access_gps_page.dart';
import 'package:eco_app3/views/loading_page.dart';
import 'package:eco_app3/views/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ( _ ) => UserLocationBloc() ),
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: LoadingPage(),
        routes: {
          'mapa'      : ( _ ) => MapPage(),
          'loading'   : ( _ ) => LoadingPage(),
          'acceso_gps': ( _ ) => AccessGpsPage(),
        },
      ),
    );
  }
}
