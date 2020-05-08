import 'package:flutter/material.dart';

import './text.dart';

class InputTextRow extends StatelessWidget {
  final TextEditingController inputController;
  final String label;

  InputTextRow({
    this.inputController,
    this.label,
  });

  @override
  Widget build(ctx) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FLabel(label: label, fontSize: 12),
          TextField(controller: inputController),
        ],
    );
  }
}
