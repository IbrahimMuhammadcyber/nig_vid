import 'package:flutter/material.dart';

import 'theme.dart';

/// NIG_VID symbol: a rounded square with a play triangle.
class NvLogo extends StatelessWidget {
  final double size;
  const NvLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          colors: <Color>[NvColors.violet, NvColors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: size * 0.64),
    );
  }
}

/// Logo symbol plus the NIG_VID wordmark.
class NvWordmark extends StatelessWidget {
  const NvWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        NvLogo(size: 36),
        SizedBox(width: 10),
        Text(
          'NIG_VID',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: NvColors.text,
          ),
        ),
      ],
    );
  }
}

/// A rounded elevated surface used for cards and sections.
class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: NvColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? NvColors.border),
      ),
      child: child,
    );
  }
}

/// Small label chip, for example "Planned" or "Available".
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: NvColors.text,
        ),
      ),
    );
  }
}
