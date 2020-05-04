import 'package:flutter/material.dart';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../store/store.dart';

class Toolbar extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider(
        store: store,
        child: Container(
            height: 100,
            color: Color(0xFF00FFFF),
            child: Text(store.state.currentAtlas?.id),
        ),
    );
  }
}
