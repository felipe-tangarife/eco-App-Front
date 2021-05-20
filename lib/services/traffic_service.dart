import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:eco_app3/helpers/debouncer.dart';
import 'package:eco_app3/models/reverse_query_response.dart';

import 'package:eco_app3/models/search_response.dart';
import 'package:eco_app3/models/traffic_response.dart';

class TrafficService {

  // Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService(){
    return _instance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400 ));

  final StreamController<SearchResponse> _suggestionStreamController = new StreamController<SearchResponse>.broadcast();
  Stream<SearchResponse> get suggestionStream => this._suggestionStreamController.stream;


  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey  = 'pk.eyJ1IjoiZmVsaXBldGFuZ2FyaWZlIiwiYSI6ImNrb3gycnZqbzA1azEydnI5Nm1mZnU3djQifQ.ksyUtEEXHK-cqEmuL9NJYw';


  Future<DrivingResponse> getCoordsStartDestination( LatLng start, LatLng destination ) async {
    print(start);
    print(destination);
    final coordString = '${ start.longitude },${ start.latitude };${ destination.longitude },${ destination.latitude }';
    final url = '${ this._baseUrlDir }/mapbox/driving/$coordString';

    final resp = await this._dio.get( url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es',
    });

    print(resp);

    final data = DrivingResponse.fromJson(resp.data);
    print(data.routes);
    return data;

  }

  Future<SearchResponse> getQueryResults( String search, LatLng proximity ) async {

    final url = '${ this._baseUrlGeo }/mapbox.places/$search.json';

    try {
        final resp = await this._dio.get(url, queryParameters: {
          'access_token': this._apiKey,
          'autocomplete': 'true',
          'proximity'   : '${ proximity.longitude },${ proximity.latitude }',
          'language'    : 'es',
        });

        final searchResponse = searchResponseFromJson( resp.data );
        print(searchResponse);
        return searchResponse;

    } catch (e) {
      return SearchResponse( features: [] );
    }

  
  }

  void getSuggestionByQuery( String search, LatLng proximity ) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await this.getQueryResults(value, proximity);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = search;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel()); 

  }

  Future<ReverseQueryResponse> getCoordsInfo( LatLng destinationCoords ) async {

    final url = '${ this._baseUrlGeo }/mapbox.places/${ destinationCoords.longitude },${ destinationCoords.latitude }.json';

    final resp = await this._dio.get( url, queryParameters: {
      'access_token': this._apiKey,
      'language': 'es',
    });

    final data = reverseQueryResponseFromJson( resp.data );

    return data;


  }


}

