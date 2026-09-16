import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class FloatingCharacterWidget extends StatefulWidget {
  const FloatingCharacterWidget({
    super.key,
    required this.char,
    this.size = 64.0,
    this.delay = 0.0,
    this.duration = const Duration(seconds: 4),
  });

  final String char;
  final double size;
  final double delay;
  final Duration duration;

  @override
  State<FloatingCharacterWidget> createState() => _FloatingCharacterWidgetState();
}

class _FloatingCharacterWidgetState extends State<FloatingCharacterWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Apply delay before starting loop
    if (widget.delay > 0) {
      Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
        if (mounted) {
          _controller.repeat(reverse: true);
        }
      });
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        final dy = math.sin(value * math.pi * 2) * 12.0;
        final rotX = math.sin(value * math.pi) * 0.15;
        final rotY = math.cos(value * math.pi) * 0.15;

        return Transform(
          transform: Matrix4.translationValues(0.0, dy, 0.0)
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(rotX)
            ..rotateY(rotY),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size * 0.25),
          boxShadow: const [
            BoxShadow(
              color: Color(0x59000000), // rgba(0,0,0,0.35)
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.size * 0.25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(widget.size * 0.25),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  widget.char,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: widget.size * 0.45,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: const Color(0xB3B95FFF),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
