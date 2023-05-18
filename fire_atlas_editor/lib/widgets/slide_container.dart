import 'package:flutter/widgets.dart';

class SlideContainer extends StatefulWidget {
  final Widget child;
  final Offset from;
  final Offset to;
  final Duration duration;
  final Curve curve;
  final void Function(AnimationController) onFinish;

  const SlideContainer({
    required this.child,
    required this.onFinish,
    this.from = Offset.zero,
    this.to = Offset.zero,
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.easeInExpo,
    super.key,
  });

  @override
  State createState() => _SlideContainer();
}

class _SlideContainer extends State<SlideContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward().whenComplete(() {
        widget.onFinish.call(_controller);
      });

    _offsetAnimation = Tween<Offset>(
      begin: widget.from,
      end: widget.to,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}
