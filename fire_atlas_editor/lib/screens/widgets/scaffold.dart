import 'package:fire_atlas_editor/screens/widgets/messages_board.dart';
import 'package:fire_atlas_editor/screens/widgets/modal_container.dart';
import 'package:flutter/material.dart';

class FScaffold extends StatelessWidget {
  final Widget child;

  const FScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: child),
          const Positioned.fill(child: ModalContainer()),
          const Positioned(
            right: 10,
            top: 10,
            child: MessagesBoard(),
          ),
        ],
      ),
    );
  }
}
