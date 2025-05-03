import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MusilyLogo extends StatelessWidget {
  final double size;
  final Color? color;
  const MusilyLogo({super.key, this.size = 100, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/musily_logo.svg',
      width: 100,
      height: 100,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.primary,
        BlendMode.srcIn,
      ),
    );
  }
}
