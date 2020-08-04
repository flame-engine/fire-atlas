import 'package:flutter/material.dart';

import './modal_container.dart';
import './messages_board.dart';

class FScaffold extends StatelessWidget {
  final Widget child;

  FScaffold({this.child});

  @override
  Widget build(ctx) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(child: child),
        Positioned.fill(child: ModalContainer()),
        Positioned(
          right: 10,
          top: 10,
          child: MessagesBoard(),
        ),
      ]),
    );
  }
}
