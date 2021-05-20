part of 'widgets.dart';


class BtnLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final mapBloc = context.read<MapBloc>();
    final userLocationBloc = context.read<UserLocationBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10 ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon( Icons.my_location, color: Colors.black87 ),
          onPressed: () {

            final destination = userLocationBloc.state.location;
            print(destination);
            mapBloc.moveCamera(destination);

          },
        ),
      ),
    );
  }
}


