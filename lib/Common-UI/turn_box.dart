import 'package:flutter/material.dart';

class TurnBox extends StatefulWidget {
  const TurnBox({super.key,
    this.turns = 0.0,
    this.speed = 200,
    required this.child
  });

  final double turns;
  final int speed;
  final Widget child;


  @override
  State<TurnBox> createState() => _TurnBoxState();
}

class _TurnBoxState extends State<TurnBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,
      lowerBound: -double.infinity,
      upperBound: double.infinity
    );
    _controller.value = widget.turns;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RotationTransition(turns: _controller,
      child: widget.child,
    );
  }
  @override
  void didUpdateWidget(covariant TurnBox oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.turns != widget.turns) {
      _controller.animateTo(widget.turns,
        duration: Duration(milliseconds: widget.speed),
        curve: Curves.easeOut
      );
    }
  }
}
