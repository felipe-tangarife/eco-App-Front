part of 'custom_markers.dart';

class MarkerDestinationPainter extends CustomPainter {

  final String description;
  final double meters;

  MarkerDestinationPainter(this.description, this.meters);

  @override
  void paint(Canvas canvas, Size size) {
      
    final double blackCircleR  = 20;
    final double whiteCircleR = 7;

    Paint paint = new Paint()
      ..color = Colors.black;

    // Dibujar circulo negro
    canvas.drawCircle(
      Offset( blackCircleR , size.height - whiteCircleR),
      20, 
      paint
    );

    // Circulo Blanco
    paint.color = Colors.white;

    canvas.drawCircle(
      Offset( blackCircleR, size.height - blackCircleR ),
        whiteCircleR,
      paint
    );

    // Sombra
    final Path path = new Path();

    path.moveTo( 0, 20 );
    path.lineTo( size.width - 10, 20 );
    path.lineTo( size.width - 10, 100 );
    path.lineTo( 0, 100 );

    canvas.drawShadow(path, Colors.black87, 10, false);

    // Caja Blanca
    final whiteBox = Rect.fromLTWH( 0, 20, size.width - 10, 80);
    canvas.drawRect( whiteBox, paint);

    // Caja Negra
    paint.color = Colors.black;
    final blackBox = Rect.fromLTWH( 0, 20, 70, 80);
    canvas.drawRect( blackBox, paint);

    // Dibujar textos
    double kms = this.meters / 1000;
    kms = ( kms * 100).floor().toDouble();
    kms = kms / 100;

    TextSpan textSpan = new TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400 ),
      text: '$kms'
    );

    TextPainter textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 70,
      minWidth: 70
    );

    textPainter.paint(canvas, Offset( 0, 35));

    // Minutos
    textSpan = new TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400 ),
      text: 'Km'
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 70
    );

    textPainter.paint(canvas, Offset( 20, 67 ));

    // Mi ubicación
    textSpan = new TextSpan(
      style: TextStyle( color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400 ),
      text: this.description
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 2,
      ellipsis: '...'
    )..layout(
      maxWidth: size.width - 100,
    );

    textPainter.paint(canvas, Offset( 90, 35 ));
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;


}