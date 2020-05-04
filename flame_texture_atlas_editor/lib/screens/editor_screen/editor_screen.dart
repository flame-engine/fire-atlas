import 'package:flutter/material.dart';

import './widgets/toolbar.dart';
import './widgets/selection_canvas.dart';
import './widgets/selection_list.dart';
import './widgets/preview.dart';

class EditorScreen extends StatelessWidget {
  @override
  Widget build(_) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Toolbar(),

              // Body
              Expanded(
                  child: Row(
                      children: [
                        Expanded(
                            child: SelectionCanvas(),
                        ),
                        Container(
                            width: 400,
                            child: Column(
                                children: [
                                  Expanded(
                                      child: Preview(),
                                  ),
                                  Expanded(
                                      child: SelectionList(),
                                  ),
                                ],
                            ),
                        ),
                      ],
                  ),
              )
            ],
        ),
    );
  }
}
