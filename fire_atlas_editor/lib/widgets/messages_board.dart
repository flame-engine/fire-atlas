import 'package:flutter/material.dart';

import '../vendor/micro_store/micro_store.dart';
import '../store/store.dart';
import '../store/actions/editor_actions.dart';

import './slide_container.dart';
import './color_badge.dart';

class MessagesBoard extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider<FireAtlasState>(
        store: Store.instance,
        builder: (ctx, store) {

          return Column(
              children: store.state.messages.map((message) {
                return _Message(
                    key: Key(message.message),
                    message: message,
                    onVanish: () {
                      store.dispatch(DismissMessageAction(message: message));
                    }
                );
              }).toList().cast()
          );
        },
    );
  }
}

class _Message extends StatelessWidget {
  final Message message;
  final VoidCallback onVanish;

  _Message({
    this.message,
    this.onVanish,
    Key key,
  }): super(key: key);

  @override
  Widget build(ctx) {
    final color = message.type == MessageType.INFO
        ? Theme.of(ctx).hintColor
        : Theme.of(ctx).errorColor;

    return SlideContainer(
        key: key,
        curve: Curves.easeOutQuad,
        onFinish: (controller) {
          Future.delayed(Duration(milliseconds: 2500)).then((_) {
            controller.reverse().whenComplete(() {
              onVanish();
            });
          });
        },
        from: Offset(1.2, 0.0),
        child: ColorBadge(
            color: color,
            label: message.message,
        )
    );
  }
}
