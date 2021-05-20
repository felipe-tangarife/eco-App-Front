part of 'helpers.dart';



Future<BitmapDescriptor> getMarkerStartIcon( int seconds ) async {

  final recorder = new ui.PictureRecorder();
  final canvas   = new ui.Canvas(recorder);
  final size     = new ui.Size( 350, 150 );

  final minutes = (seconds / 60).floor();

  final markerStart = new MarkerStartPainter( minutes );
  markerStart.paint(canvas, size);

  final picture = recorder.endRecording();
  final image   = await picture.toImage( size.width.toInt(), size.height.toInt() );
  final byteData = await image.toByteData( format: ui.ImageByteFormat.png );

  return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());

}

Future<BitmapDescriptor> getMarkerDestinationIcon( String description, double meters ) async {

  final recorder = new ui.PictureRecorder();
  final canvas   = new ui.Canvas(recorder);
  final size     = new ui.Size( 350, 150 );

  final markerDestination = new MarkerDestinationPainter(description, meters);
  markerDestination.paint(canvas, size);

  final picture = recorder.endRecording();
  final image   = await picture.toImage( size.width.toInt(), size.height.toInt() );
  final byteData = await image.toByteData( format: ui.ImageByteFormat.png );

  return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());

}