import 'package:eco_app3/bloc/map/map_bloc.dart';
import 'package:eco_app3/bloc/search/search_bloc.dart';
import 'package:eco_app3/bloc/user_location/user_location_bloc.dart';
import 'package:eco_app3/helpers/helpers.dart';
import 'package:eco_app3/models/search_result.dart';
import 'package:eco_app3/search/search_destination.dart';
import 'package:eco_app3/services/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:polyline/polyline.dart' as Poly;

part 'btn_location.dart';
part 'btn_my_route.dart';
part 'btn_follow_location.dart';
part 'search_bar.dart';
part 'manual_mark.dart';