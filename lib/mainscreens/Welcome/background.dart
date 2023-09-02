import 'package:flutter/material.dart';
import 'dart:math';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
    this.topImage = "assets/images/main_top.png",
    this.bottomImage = "assets/images/main_bottom_2.png",
  }) : super(key: key);

  final String topImage, bottomImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                topImage,
                width: 120,
              ),
            ),
            Positioned(
              right: 0,
              top: 630,
              child: Transform.rotate(
                angle: 60 * 3.141592653589793 / 180,
                child: Image.asset(bottomImage, width: 140),
              ),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
