part of 'widgets.dart';

class ManualMark extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        print(state);
        if ( state.manualSelect ) {
          return _BuildManualMark();
        } else {
          return Container();
        }

      },
    );
    
  }

}

class _BuildManualMark extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [

        Positioned(
          top: 70,
          left: 20,
          child: FadeInLeft(
            duration: Duration(milliseconds: 150),
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon( Icons.arrow_back, color: Colors.black ),
                onPressed: () {
                  context.read<SearchBloc>().add( OnDisableManualMark() );
                }
              ),
            ),
          )
        ),

        Center(
          child: Transform.translate(
            offset: Offset(0, -12),
            child: BounceInDown(
              from: 200,
              child: Icon( Icons.location_on, size: 50 )
            )
          ),
        ),

        // Boton de confirmar destino
        Positioned(
          bottom: 70,
          left: 40,
          child: FadeIn(
            child: MaterialButton(
              minWidth: width - 120,
              child: Text('Confirmar destino', style: TextStyle( color: Colors.white ) ),
              color: Colors.green,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                this.calculateDestination( context );
              }
            ),
          )
        ),


      ],
    );
  }


  void calculateDestination( BuildContext context ) async {
    
    calculateAlert(context);

    final trafficService = new TrafficService();
    final mapBloc = context.read<MapBloc>();

    final start  = context.read<UserLocationBloc>().state.location;
    final dest = mapBloc.state.centralLocation;


    final reverseQueryResponse = await trafficService.getCoordsInfo(dest);

    final trafficResponse = await trafficService.getCoordsStartDestination(start, dest);

    final geometry  = trafficResponse.routes[0].geometry;
    final duration  = trafficResponse.routes[0].duration;
    final distance = trafficResponse.routes[0].distance;
    final destinationName = reverseQueryResponse.features[0].text;

    // Decodificar los puntos del geometry
    final points = Poly.Polyline.Decode( encodedString: geometry, precision: 6 ).decodedCoords;
    final List<LatLng> coords = points.map(
      (point) => LatLng(point[0], point[1])
    ).toList();

    mapBloc.add( OnCreateRouteStartDestination(coords, distance, duration, destinationName) );

    Navigator.of(context).pop();
    context.read<SearchBloc>().add( OnDisableManualMark() );
  }

}