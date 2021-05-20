part of 'widgets.dart';


class BtnMyRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final mapBloc = context.read<MapBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10 ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon( Icons.more_horiz_rounded, color: Colors.black87 ),
          onPressed: () {
              mapBloc.add(OnMarkPath());
          },
        ),
      ),
    );
  }
}


