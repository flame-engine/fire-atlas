import 'package:flutter/material.dart';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../store/store.dart';

import '../../../widgets/container.dart';
import '../../../widgets/icon_button.dart';

class Toolbar extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider<FireAtlasState>(
        store: Store.instance,
        builder: (ctx, store) => FContainer(
            height: 60,
            child: Column(
                children: [
                  Text('Working on: ${store.state.currentAtlas?.id}'),
                  Row(
                      children: [
                        FIconButton(
                            iconData: Icons.save,
                            onPress: () {
                              print('asd');
                            }
                        ),
                      ]
                  ),
                ],
            ),
        ),
    );
  }
}
