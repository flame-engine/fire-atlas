import 'package:flutter/material.dart';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../store/store.dart';

import '../../../widgets/container.dart';

class Toolbar extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider(
        store: store,
        child: FContainer(
            height: 100,
            child: Text(store.state.currentAtlas?.id),
        ),
    );
  }
}
