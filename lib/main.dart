import 'package:eco_app3/bloc/map/map_bloc.dart';
import 'package:eco_app3/bloc/search/search_bloc.dart';
import 'package:eco_app3/bloc/user_location/user_location_bloc.dart';
import 'package:eco_app3/views/access_gps_page.dart';
import 'package:eco_app3/views/loading_page.dart';
import 'package:eco_app3/views/login.dart';
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
        BlocProvider(create: ( _ ) => MapBloc() ),
        BlocProvider(create: ( _ ) => SearchBloc() ),
      ],
      child: MaterialApp(
        title: 'Eco App',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          'map'      : ( _ ) => MapPage(),
          'loading'   : ( _ ) => LoadingPage(),
          'access_gps': ( _ ) => AccessGpsPage(),
          'login': ( _ ) => LoginPage(),
        },
      ),
    );
  }
}
