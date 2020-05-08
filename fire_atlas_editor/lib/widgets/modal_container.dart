import 'package:flutter/material.dart';

import '../vendor/micro_store/micro_store.dart';
import '../store/store.dart';
import '../store/actions/editor_actions.dart';

import './container.dart';
import './icon_button.dart';

class ModalContainer extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider<FireAtlasState>(
        store: Store.instance,
        builder: (ctx, store) {

          if (store.state.modal != null) {
            return Stack(
                children: [
                  Positioned.fill(
                      child: Opacity(
                          opacity: 0.9,
                          child: Container(color: Theme.of(ctx).dialogBackgroundColor),
                      ),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 100,
                      bottom: 100,
                      child: Center(child: Opacity(opacity: 1, child: FContainer(
                          width: store.state.modal.width,
                          color: Theme.of(ctx).dialogBackgroundColor,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: FIconButton(
                                        iconData: Icons.close,
                                        color: Theme.of(ctx).buttonColor,
                                        onPress: () {
                                          store.dispatch(CloseEditorModal());
                                        }
                                    ),
                                ),
                                Expanded(child: store.state.modal.child),
                              ]
                          ),
                      ))),
                  ),
                ],
            );
          }

          return Container(width: 0, height: 0);
        },
    );
  }
}
