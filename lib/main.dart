import 'package:flutter/material.dart';
import 'inicio.dart';

void main() => runApp(const MyApp());

// --- Pintor Personalizado para el Toldo de la Tienda con Logotipo ---
class AwningPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stripePaint = Paint();
    const stripeWidth = 40.0;
    const scallopRadius = 15.0;
    final scallopHeight = scallopRadius;
    final mainBarHeight = size.height - scallopHeight;

    // 1. Dibuja las franjas rojas y blancas
    for (double i = 0; i < size.width; i += stripeWidth) {
      stripePaint.color = (i / stripeWidth).floor() % 2 == 0
          ? Colors.red.shade600
          : Colors.white;
      canvas.drawRect(
          Rect.fromLTWH(i, 0, stripeWidth, mainBarHeight), stripePaint);
    }

    // 2. Dibuja el logotipo central
    final centerX = size.width / 2;
    final centerY = mainBarHeight / 2;
    final logoRadius = mainBarHeight * 0.7; // El radio del logo

    final circlePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(centerX, centerY), logoRadius, circlePaint);

    final circleBorderPaint = Paint()
      ..color = Colors.red.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(Offset(centerX, centerY), logoRadius, circleBorderPaint);

    // Dibuja el texto "MT" en el centro del círculo
    const textSpan = TextSpan(
      text: 'MT',
      style: TextStyle(
          color: Colors.red, 
          fontSize: 28, 
          fontWeight: FontWeight.bold, 
          fontFamily: 'Georgia'),
    );
    final textPainter = TextPainter(
        text: textSpan, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    textPainter.layout();
    final textOffset = Offset(
        centerX - textPainter.width / 2, centerY - textPainter.height / 2);
    textPainter.paint(canvas, textOffset);

    // 3. Dibuja el borde festoneado (medios círculos)
    final scallopPath = Path();
    scallopPath.moveTo(-2, mainBarHeight);
    for (double i = 0; i < size.width + 2; i += (scallopRadius * 2)) {
      scallopPath.relativeArcToPoint(
        Offset(scallopRadius * 2, 0),
        radius: const Radius.circular(scallopRadius),
        clockwise: false,
      );
    }
    scallopPath.lineTo(size.width, mainBarHeight);
    scallopPath.close();

    final trimPaint = Paint()..color = Colors.red.shade600;
    canvas.drawPath(scallopPath, trimPaint);
    canvas.drawRect(
        Rect.fromLTWH(0, mainBarHeight - 2, size.width, 4), trimPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.indigo.shade700;
    final Color backgroundColor = Colors.blueGrey.shade50;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS MiTiendita',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        body: Column(
          children: [
            // --- Widget del Toldo con Logotipo ---
            SafeArea(
              bottom: false,
              child: CustomPaint(
                size: const Size(double.infinity, 80), // Aumentamos la altura para el logo
                painter: AwningPainter(),
              ),
            ),

            // --- Contenido Principal de la Página ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Text(
                      'POS MiTiendita',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: Color(0xFF1A237E), // Indigo 900
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Todo listo para empezar a vender',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Inicio()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Iniciar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
