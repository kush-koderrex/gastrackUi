import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/utils/utils.dart';

class RadarUI extends StatefulWidget {
  @override
  _RadarUIState createState() => _RadarUIState();
}

class _RadarUIState extends State<RadarUI> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(); // Repeat indefinitely to simulate the radar sweep
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radar UI',style: AppStyles.appBarTextStyle,),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Radar Circles
            buildRadarCircle(200, Colors.purple.withOpacity(0.1)),
            buildRadarCircle(150, Colors.purple.withOpacity(0.2)),
            buildRadarCircle(100, Colors.purple.withOpacity(0.3)),
            buildRadarCircle(50, Colors.purple.withOpacity(0.4)),

            // Radar Beam
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: CustomPaint(
                    painter: RadarBeamPainter(),
                    child: Container(),
                  ),
                );
              },
            ),

            // Mock Devices (Positioned randomly around the radar)
            Positioned(
              top: 100,
              left: 120,
              child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
            ),
            Positioned(
              bottom: 90,
              right: 80,
              child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
            ),
            Positioned(
              bottom: 150,
              left: 140,
              child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to create radar circles with varying opacity
  Widget buildRadarCircle(double radius, Color color) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

// CustomPainter for the radar beam sweep
class RadarBeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.green.withOpacity(0.7),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 200));

    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: 200),
      -pi / 2,
      pi / 6, // Radar beam width
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint the radar beam
  }
}
