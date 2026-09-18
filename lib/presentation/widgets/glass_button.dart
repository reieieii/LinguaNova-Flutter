import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum GlassButtonVariant { primary, glass, glassWhite, outline, ghost }

class GlassButton extends StatefulWidget {
  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = GlassButtonVariant.primary,
    this.icon,
    this.isLarge = false,
    this.fullWidth = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final GlassButtonVariant variant;
  final Widget? icon;
  final bool isLarge;
  final bool fullWidth;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final padding = widget.isLarge
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 16)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    Widget content = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          const SizedBox(width: 8),
        ],
        DefaultTextStyle(
          style: TextStyle(
            color: _getTextColor(),
            fontSize: widget.isLarge ? 17 : 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          child: widget.child,
        ),
      ],
    );

    Decoration decoration;
    switch (widget.variant) {
      case GlassButtonVariant.primary:
        decoration = BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.brand700,
              AppColors.brand500,
              AppColors.brand300,
            ],
          ),
          borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
          border: Border.all(
            color: AppColors.brand300.withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brand500.withValues(alpha: _isHovered ? 0.6 : 0.35),
              blurRadius: _isHovered ? 35 : 20,
              spreadRadius: 0,
            ),
          ],
        );
        break;
      case GlassButtonVariant.glass:
        decoration = BoxDecoration(
          color: AppColors.brand500.withValues(alpha: _isHovered ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
          border: Border.all(
            color: AppColors.brand500.withValues(alpha: _isHovered ? 0.5 : 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brand500.withValues(alpha: _isHovered ? 0.3 : 0.15),
              blurRadius: _isHovered ? 22 : 12,
              spreadRadius: 0,
            ),
          ],
        );
        break;
      case GlassButtonVariant.glassWhite:
        decoration = BoxDecoration(
          color: AppColors.brand700.withValues(alpha: _isHovered ? 0.3 : 0.15),
          borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
          border: Border.all(
            color: AppColors.brand300.withValues(alpha: _isHovered ? 0.4 : 0.2),
            width: 1,
          ),
        );
        break;
      case GlassButtonVariant.outline:
        decoration = BoxDecoration(
          color: _isHovered
              ? AppColors.brand500.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
          border: Border.all(
            color: AppColors.brand500.withValues(alpha: 0.5),
            width: 1,
          ),
        );
        break;
      case GlassButtonVariant.ghost:
        decoration = BoxDecoration(
          color: _isHovered ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
        );
        break;
    }

    final double scale = _isPressed ? 0.98 : (_isHovered ? 1.02 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.diagonal3Values(scale, scale, 1.0),
          transformAlignment: Alignment.center,
          width: widget.fullWidth ? double.infinity : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
            child: widget.variant == GlassButtonVariant.glass || widget.variant == GlassButtonVariant.glassWhite
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: padding,
                      decoration: decoration,
                      child: content,
                    ),
                  )
                : Container(
                    padding: padding,
                    decoration: decoration,
                    child: content,
                  ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor() {
    switch (widget.variant) {
      case GlassButtonVariant.primary:
        return Colors.white;
      case GlassButtonVariant.glass:
      case GlassButtonVariant.outline:
        return AppColors.brand300;
      case GlassButtonVariant.glassWhite:
        return Colors.white;
      case GlassButtonVariant.ghost:
        return _isHovered ? Colors.white : AppColors.textMuted;
    }
  }
}
