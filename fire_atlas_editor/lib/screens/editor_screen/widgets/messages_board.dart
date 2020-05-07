import 'package:flutter/material.dart';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../store/store.dart';
import '../../../models/fire_atlas.dart';
import '../../../store/actions/editor_actions.dart';

import '../../../widgets/container.dart';
import '../../../widgets/icon_button.dart';


class MessagesBoard extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider<FireAtlasState>(
        store: Store.instance,
        builder: (ctx, store) {

          return Column(
              children: store.state.messages.map((message) {
                return _Message(message: message);
              }).toList().cast()
          );
        },
    );
  }
}

class _Message extends StatelessWidget {
  final Message message;

  _Message({
    this.message,
  });

  @override
  Widget build(ctx) {
    final color = message.type == MessageType.INFO
        ? Theme.of(ctx).hintColor
        : Theme.of(ctx).errorColor;

    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        color: color,
        child: Text(message.message),
    );
  }
}
