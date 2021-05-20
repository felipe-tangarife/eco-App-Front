part of 'widgets.dart';

class SearchBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        print(state);
        if ( state.manualSelect ) {
          return Container();
        } else {
          return FadeInDown(
            duration: Duration( milliseconds: 300 ),
            child: buildSearchbar( context )
          );
        }

      },
    );

  }
  
  
  Widget buildSearchbar(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric( horizontal: 30 ),
        width: width,
        child: GestureDetector(
          onTap: () async {
            
            final proximity = context.read<UserLocationBloc>().state.location;
            final history  = context.read<SearchBloc>().state.history;

            final result = await showSearch(
              context: context, 
              delegate: SearchDestination( proximity, history )
            );
            this.returnSearchResult( context, result );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            width: double.infinity,
            child: Text('¿Dónde quieres ir?', style: TextStyle( color: Colors.black87 )),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
              ]
            ),
          ),
        ),
      ),
    );
  }


  Future returnSearchResult(BuildContext context, SearchResult result ) async {
    print("aquii");
    if ( result.cancel ) return;

    if ( result.manual ) {
      context.read<SearchBloc>().add( OnActiveManualMark() );
      return;
    }

    calculateAlert(context);

    final trafficService = new TrafficService();
    final mapBloc = context.read<MapBloc>();

    final start  = context.read<UserLocationBloc>().state.location;
    final destination = result.position;

    final drivingResponse = await trafficService.getCoordsStartDestination(start, destination);
    print(drivingResponse.routes[0].geometry);

    final geometry  = drivingResponse.routes[0].geometry;
    final duration  = drivingResponse.routes[0].duration;
    final distance = drivingResponse.routes[0].distance;
    final destinationName = result.destinationName;

    final points = Poly.Polyline.Decode( encodedString: geometry, precision: 6 );
    final List<LatLng> coords = points.decodedCoords.map(
      ( point ) => LatLng( point[0], point[1])
    ).toList();

    mapBloc.add( OnCreateRouteStartDestination(coords, distance, duration, destinationName) );

    Navigator.of(context).pop();

    final searchBloc = context.read<SearchBloc>();
    searchBloc.add( OnAddToHistory( result ) );

  }



}