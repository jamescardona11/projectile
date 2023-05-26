import 'package:flutter/material.dart';

/// ```
/// InputTextWidget(
///   hint: 'Enter your email',
///   leadingIcon: Icons.email,
///   onChanged: (value) {},
/// )
/// ```

class InputTextWidget extends StatelessWidget {
  const InputTextWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 15,
    this.hint,
    this.leadingIcon,
    this.trailing,
    this.iconColor = Colors.grey,
    this.background = Colors.transparent,
    this.borderColor = Colors.grey,
    this.validIconColor = Colors.blueGrey,
    this.cursorColor,
    this.obscureText = false,
    this.maxLines = 1,
    this.isValid,
    this.onChanged,
    this.boxShadow,
    this.keyboardType,
  });

  InputTextWidget.password({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 15,
    this.hint,
    this.leadingIcon,
    this.iconColor = Colors.grey,
    this.background = Colors.transparent,
    this.borderColor = Colors.grey,
    this.validIconColor = Colors.blueGrey,
    this.cursorColor,
    Color suffixIconColor = Colors.grey,
    Color? suffixEnableIconColor,
    this.obscureText = true,
    this.isValid,
    this.onChanged,
    this.boxShadow,
    this.keyboardType,
  })  : maxLines = 1,
        trailing = _TrailingVisibilityWidget(
          color: suffixIconColor,
          enableColor: suffixEnableIconColor,
        );

  final double? width;
  final double? height;
  final double borderRadius;
  final int maxLines;
  final String? hint;
  final IconData? leadingIcon;
  final Widget? trailing;
  final Color iconColor;
  final Color validIconColor;
  final Color? cursorColor;
  final Color background;
  final Color borderColor;
  final bool? isValid;
  final bool obscureText;
  final BoxShadow? boxShadow;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    // final neutralColor = borderColor.withOpacity(0.5);
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(
          color: borderColor.withOpacity(0.5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow != null ? [boxShadow!] : null,
      ),
      child: TextField(
        onChanged: onChanged,
        cursorColor: cursorColor,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          suffix: trailing,
          icon: Icon(
            leadingIcon,
            color: getLeadingIconColor,
          ),
          border: InputBorder.none,
        ),
        obscureText: obscureText,
      ),
    );
  }

  Color get getLeadingIconColor {
    if (isValid == null || isValid == false) {
      return iconColor;
    }
    return validIconColor;
  }
}

class _TrailingVisibilityWidget extends StatelessWidget {
  const _TrailingVisibilityWidget({
    required this.color,
    this.enableColor,
  });

  final Color color;
  final Color? enableColor;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.remove_red_eye,
      color: enableColor ?? color,
    );
  }
}
