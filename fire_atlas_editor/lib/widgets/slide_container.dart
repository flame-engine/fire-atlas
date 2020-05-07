import 'package:flutter/widgets.dart';

class SlideContainer extends StatefulWidget {
  final Widget child;
  final Offset from;
  final Offset to;
  final Duration duration;
  final Curve curve;
  final void Function(AnimationController) onFinish;

  SlideContainer({
    this.child,
    this.from = const Offset(0.0, 0.0),
    this.to = const Offset(0.0, 0.0),
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.easeInExpo,
    this.onFinish,
    Key key,
  }): super(key: key);

  @override
  createState() => _SlideContainer();
}

class _SlideContainer extends State<SlideContainer> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward().whenComplete(() {
      widget.onFinish?.call(_controller);
    });

    _offsetAnimation = Tween<Offset>(
      begin: widget.from,
      end: widget.to,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}

