import 'package:eco_app3/models/search_response.dart';
import 'package:eco_app3/models/search_result.dart';
import 'package:eco_app3/services/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;


class SearchDestination extends SearchDelegate<SearchResult> {

  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximity;
  final List<SearchResult> history;

  SearchDestination( this.proximity, this.history )
    : this.searchFieldLabel = 'Buscar...',
      this._trafficService = new TrafficService();


  @override
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton(
        icon: Icon( Icons.clear ), 
        onPressed: () => this.query = ''
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon( Icons.arrow_back_ios ), 
      onPressed: () => this.close(context, SearchResult(cancel: true) )
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return this._buildSuggestionResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if ( this.query.length == 0 ) {
      return ListView(
        children: [

          ListTile(
            leading: Icon( Icons.location_on ),
            title: Text('Colocar ubicación manualmente'),
            onTap: () {
              this.close(context, SearchResult( cancel: false, manual: true ) );
            },
          ),

          ...this.history.map(
            ( result ) => ListTile(
              leading: Icon( Icons.history ),
              title: Text( result.destinationName ),
              subtitle: Text( result.description ),
              onTap: () {
                this.close(context, result );
              },
            )
          ).toList()


        ],
      );

    }

    return this._buildSuggestionResults();

  }


  Widget _buildSuggestionResults() {

    if ( this.query == 0 ) {
      return Container();
    }

    this._trafficService.getSuggestionByQuery( this.query.trim(), this.proximity );

    return StreamBuilder(
      stream: this._trafficService.suggestionStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {

        if ( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator());
        }

        final places = snapshot.data.features;

        if ( places.length == 0 ) {
          return ListTile(
            title: Text('No hay resultados con $query'),
          );
        }

        
        return ListView.separated(
          itemCount: places.length,
          separatorBuilder: ( _ , i ) => Divider(), 
          itemBuilder: ( _, i ) {
            
            final lugar = places[i];

            return ListTile(
              leading: Icon( Icons.place ),
              title: Text( lugar.textEs ),
              subtitle: Text( lugar.placeNameEs ),
              onTap: () {
                

                this.close(context,  SearchResult(
                  cancel: false,
                  manual: false,
                  position: LatLng( lugar.center[1], lugar.center[0]),
                  destinationName: lugar.textEs,
                  description: lugar.placeNameEs
                ));


              },
            );
          }, 
        );

      }
    );

  }

}