import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TopHalfCircle extends StatelessWidget {
  final String imagePath;

  const TopHalfCircle({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.56,
        color: Colors.white,
        width: double.infinity,
        child: imagePath.endsWith('.json')
            ? Lottie.asset(imagePath, fit: BoxFit.contain)
            : Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}