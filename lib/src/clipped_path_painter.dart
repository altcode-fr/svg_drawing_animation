import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'pen_renderer/pen_renderer.dart';

class ClippedPathPainter extends CustomPainter {
  ClippedPathPainter(this.drawableRoot, {required this.pathLengthLimit, this.penRenderer});

  final PictureInfo drawableRoot;
  final double pathLengthLimit;
  final PenRenderer? penRenderer;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(drawableRoot.picture);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: optimize?
    return true;
  }
}
