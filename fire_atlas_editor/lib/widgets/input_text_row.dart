import 'package:flutter/material.dart';

import './text.dart';

class InputTextRow extends StatelessWidget {
  final TextEditingController inputController;
  final String label;
  final bool enabled;
  final bool autofocus;

  InputTextRow({
    required this.inputController,
    required this.label,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FLabel(label: label, fontSize: 12),
        TextField(
          controller: inputController,
          enabled: enabled,
          autofocus: autofocus,
        ),
      ],
    );
  }
}
