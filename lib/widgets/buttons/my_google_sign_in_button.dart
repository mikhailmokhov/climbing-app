import 'package:flutter/material.dart';

import 'my_apple_sign_in_button.dart';

/// A button for Sign in With Apple
class MyGoogleSignInButton extends StatefulWidget {
  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback onPressed;

  /// A style for the authorization button.
  final AppleSignInButtonStyle style;

  /// A custom corner radius to be used by this button.
  final double cornerRadius;

  final String text;

  const MyGoogleSignInButton({
    this.onPressed,
    this.style = AppleSignInButtonStyle.white,
    this.cornerRadius = 6,
    this.text,
  })  : assert(style != null),
        assert(cornerRadius != null);

  @override
  State<StatefulWidget> createState() => _MyGoogleSignInButtonState();
}

class _MyGoogleSignInButtonState extends State<MyGoogleSignInButton> {
  bool _isTapDown = false;
  final greyFontColor = Color.fromRGBO(117, 117, 117, 1.0);

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.style == AppleSignInButtonStyle.black
        ? Colors.black
        : Colors.white;
    final textColor = widget.style == AppleSignInButtonStyle.black
        ? Colors.white
        : greyFontColor;
    final borderColor = widget.style == AppleSignInButtonStyle.white
        ? Colors.white
        : greyFontColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapDown = true),
      onTapUp: (_) {
        setState(() => _isTapDown = false);
        widget?.onPressed();
      },
      onTapCancel: () => setState(() => _isTapDown = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        constraints: BoxConstraints(
          minHeight: 32,
          maxHeight: 64,
          minWidth: 200,
        ),
        height: 50,
        decoration: BoxDecoration(
          color: _isTapDown ? Colors.grey : bgColor,
          borderRadius: BorderRadius.all(
            Radius.circular(widget.cornerRadius),
          ),
          border: Border.all(width: .7, color: borderColor),
        ),
        child: Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 1, left: 2, right: 6),
              child: SizedBox(
                height: 22,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: CustomPaint(
                    painter: _GoogleLogoPainter(),
                  ),
                ),
              ),
            ),
            Text(
              widget.text,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .3,
                  wordSpacing: -.5,
                  color: textColor,
                  fontFamily: "RobotoGoogle"),
            ),
          ],
        )),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  _GoogleLogoPainter();

//  @override
//  void _paint_(Canvas canvas, Size size) {
//    final paint = Paint()..color = color;
//    canvas.drawPath(_getApplePath(size.width, size.height), paint);
//  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0.0, 0.0);
    canvas.scale((size.width / 48.000000), (size.height / 48.000000));
    final paint = Paint();
    paint.color = Color(0xffffc107);
    canvas.drawPath(
        (Path()
          ..moveTo(43.611000, 20.083000)
          ..lineTo(42.000000, 20.083000)
          ..lineTo(42.000000, 20.000000)
          ..lineTo(24.000000, 20.000000)
          ..lineTo(24.000000, 28.000000)
          ..lineTo(35.303000, 28.000000)
          ..cubicTo(
              33.654000, 32.657000, 29.223000, 36.000000, 24.000000, 36.000000)
          ..cubicTo(
              17.373000, 36.000000, 12.000000, 30.627000, 12.000000, 24.000000)
          ..cubicTo(
              12.000000, 17.373000, 17.373000, 12.000000, 24.000000, 12.000000)
          ..cubicTo(
              27.059000, 12.000000, 29.842000, 13.154000, 31.961000, 15.039000)
          ..lineTo(37.618000, 9.382000)
          ..cubicTo(
              34.046000, 6.053000, 29.268000, 4.000000, 24.000000, 4.000000)
          ..cubicTo(
              12.955000, 4.000000, 4.000000, 12.955000, 4.000000, 24.000000)
          ..cubicTo(
              4.000000, 35.045000, 12.955000, 44.000000, 24.000000, 44.000000)
          ..cubicTo(
              35.045000, 44.000000, 44.000000, 35.045000, 44.000000, 24.000000)
          ..cubicTo(
              44.000000, 22.659000, 43.862000, 21.350000, 43.611000, 20.083000)
          ..close()),
        paint);
    paint.color = Color(0xffff3d00);
    canvas.drawPath(
        (Path()
          ..moveTo(6.306000, 14.691000)
          ..lineTo(12.877000, 19.510000)
          ..cubicTo(
              14.655000, 15.108000, 18.961000, 12.000000, 24.000000, 12.000000)
          ..cubicTo(
              27.059000, 12.000000, 29.842000, 13.154000, 31.961000, 15.039000)
          ..lineTo(37.618000, 9.382000)
          ..cubicTo(
              34.046000, 6.053000, 29.268000, 4.000000, 24.000000, 4.000000)
          ..cubicTo(
              16.318000, 4.000000, 9.656000, 8.337000, 6.306000, 14.691000)
          ..close()),
        paint);
    paint.color = Color(0xff4caf50);
    canvas.drawPath(
        (Path()
          ..moveTo(24.000000, 44.000000)
          ..cubicTo(
              29.166000, 44.000000, 33.860000, 42.023000, 37.409000, 38.808000)
          ..lineTo(31.219000, 33.570000)
          ..cubicTo(
              29.211000, 35.091000, 26.715000, 36.000000, 24.000000, 36.000000)
          ..cubicTo(
              18.798000, 36.000000, 14.381000, 32.683000, 12.717000, 28.054000)
          ..lineTo(6.195000, 33.079000)
          ..cubicTo(
              9.505000, 39.556000, 16.227000, 44.000000, 24.000000, 44.000000)
          ..close()),
        paint);
    paint.color = Color(0xff1976d2);
    canvas.drawPath(
        (Path()
          ..moveTo(43.611000, 20.083000)
          ..lineTo(42.000000, 20.083000)
          ..lineTo(42.000000, 20.000000)
          ..lineTo(24.000000, 20.000000)
          ..lineTo(24.000000, 28.000000)
          ..lineTo(35.303000, 28.000000)
          ..cubicTo(
              34.511000, 30.237000, 33.072000, 32.166000, 31.216000, 33.571000)
          ..cubicTo(
              31.217000, 33.570000, 31.218000, 33.570000, 31.219000, 33.569000)
          ..lineTo(37.409000, 38.807000)
          ..cubicTo(
              36.971000, 39.205000, 44.000000, 34.000000, 44.000000, 24.000000)
          ..cubicTo(
              44.000000, 22.659000, 43.862000, 21.350000, 43.611000, 20.083000)
          ..close()),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
