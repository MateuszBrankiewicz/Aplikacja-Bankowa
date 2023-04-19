import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VectorBackgroundLogo extends StatelessWidget {
  final double fem;
  final Widget child;

  const VectorBackgroundLogo(
      {super.key, required this.fem, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vector BG
        Positioned(
          left: 0 * fem,
          top: 0 * fem,
          child: Align(
            child: FittedBox(
              child: Image.asset(
                './lib/images/vector_bg.png',
                width: 630.91 * fem,
                height: 356 * fem,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
          left: 100 * fem,
          top: 46 * fem,
          child: SizedBox(
            width: 159 * fem,
            height: 108 * fem,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    // logo
                    left: 36 * fem,
                    top: 0 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 89 * fem,
                        height: 89 * fem,
                        child: Image.asset(
                          './lib/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0 * fem,
                    top: 64 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 300 * fem,
                        height: 44 * fem,
                        child: Text(
                          'Polonia Bank',
                          style: GoogleFonts.glegoo(
                            fontSize: 24 * fem,
                            fontWeight: FontWeight.w700,
                            height: 1.7925,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(child: child),
      ],
    );
  }
}
