part of 'custom_markers.dart';

class MarkerStartPainter extends CustomPainter {

  final int minutes;

  MarkerStartPainter(this.minutes);

  @override
  void paint(Canvas canvas, Size size) {

    final double blackCircleR  = 20;
    final double whiteCircleR = 7;

    Paint paint = new Paint()
      ..color = Colors.black;

    // Dibujar circulo negro
    canvas.drawCircle(
      Offset( blackCircleR , size.height - blackCircleR),
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

    path.moveTo( 40, 20 );
    path.lineTo( size.width - 10, 20 );
    path.lineTo( size.width - 10, 100 );
    path.lineTo( 40, 100 );

    canvas.drawShadow(path, Colors.black87, 10, false);

    // Caja Blanca
    final whiteBox = Rect.fromLTWH( 40, 20, size.width - 55, 80);
    canvas.drawRect( whiteBox, paint);

    // Caja Negra
    paint.color = Colors.black;
    final blackBox = Rect.fromLTWH( 40, 20, 70, 80);
    canvas.drawRect( blackBox, paint);

    // Dibujar textos
    TextSpan textSpan = new TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400 ),
      text: '$minutes'
    );

    TextPainter textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 70,
      minWidth: 70
    );

    textPainter.paint(canvas, Offset(40, 35));

    // Minutos
    textSpan = new TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400 ),
      text: 'Min'
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 70,
      minWidth: 70
    );

    textPainter.paint(canvas, Offset(40, 67 ));

    // Mi ubicación
    textSpan = new TextSpan(
      style: TextStyle( color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400 ),
      text: 'Mi ubicación'
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: size.width - 130,
    );

    textPainter.paint(canvas, Offset( 150, 50 ));



  }

  @override
  bool shouldRepaint(MarkerStartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerStartPainter oldDelegate) => false;
}

