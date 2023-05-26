import 'package:flutter/material.dart';

/// ```
/// EleventhButton(
///   label: 'Button',
///   primaryColor: Colors.black,
///   accentColor: Colors.white,
///   onPressed: () {},
/// ),
///
/// EleventhButton(
///   label: 'Button',
///   fill: false,
///   primaryColor: Colors.black,
///   accentColor: Colors.white,
///   onPressed: () {},
/// )
/// ```

class EleventhButton extends StatelessWidget {
  const EleventhButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width = 200,
    this.height = 50,
    this.radius = 15,
    this.fill = true,
    this.primaryColor,
    this.splashColor,
    this.textStyle,
    this.accentColor = Colors.black,
    this.icon,
    this.iconRight = true,
  }) : super(key: key);

  final double width;
  final double height;
  final double radius;
  final bool fill;
  final String label;
  final Color? primaryColor;
  final Color? splashColor;
  final Color? accentColor;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool iconRight;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: fill ? primaryColor : Colors.transparent,
          primary: splashColor ?? primaryColor,
          side: BorderSide(
            color: primaryColor ?? Colors.grey,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: icon != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: textStyle?.copyWith(
                    color: fill ? accentColor : primaryColor,
                  ) ??
                  TextStyle(
                    color: fill ? accentColor : primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
            ),
            if (icon != null)
              Icon(
                icon,
                color: accentColor,
              ),
          ],
        ),
      ),
    );
  }
}
