import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flutter/material.dart';

class InputTextRow extends StatelessWidget {
  final TextEditingController inputController;
  final String label;
  final bool enabled;
  final bool autofocus;

  const InputTextRow({
    Key? key,
    required this.inputController,
    required this.label,
    this.enabled = true,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Column(
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
