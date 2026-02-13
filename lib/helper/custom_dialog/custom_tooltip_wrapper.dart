import 'package:flutter/material.dart';

class CustomTooltipWrapper extends StatefulWidget {
  final Widget child;
  final String message;

  const CustomTooltipWrapper({
    super.key,
    required this.child,
    required this.message,
  });

  @override
  State<CustomTooltipWrapper> createState() => _CustomTooltipWrapperState();
}

class _CustomTooltipWrapperState extends State<CustomTooltipWrapper> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;

  bool get _isTooltipVisible => _overlayEntry != null;

  /*
  void _showTooltip() {
    if (_overlayEntry != null) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    if (renderBox == null) return;

    final targetGlobalPosition = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideTooltip, // Tap outside hides tooltip
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: targetGlobalPosition.dx,
              top: targetGlobalPosition.dy - 50, // Position above child
              child: Material(
                color: Colors.transparent,
                child: _TooltipContent(message: widget.message),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
  */

  void _showTooltip() {
    if (_overlayEntry != null) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) return;

    final overlayBox =
    overlay.context.findRenderObject() as RenderBox;

    final position =
    renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);

    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hideTooltip,
        child: Stack(
          children: [
            Positioned(
              left: position.dx + size.width / 2 - 50, // center align
              top: position.dy - 60,
              child: Material(
                color: Colors.transparent,
                child: _TooltipContent(message: widget.message),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleTooltip() {
    if (_isTooltipVisible) {
      _hideTooltip();
    } else {
      _showTooltip();
    }
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: _toggleTooltip,
      child: widget.child,
    );
  }
}

class _TooltipContent extends StatelessWidget {
  final String message;

  const _TooltipContent({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        CustomPaint(
          size: const Size(14, 7),
          painter: _TooltipArrowPainter(),
        ),
      ],
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
