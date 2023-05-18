import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/container.dart';
import 'package:fire_atlas_editor/widgets/icon_button.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class _ModalContainerSlice extends Equatable {
  final ModalState? modal;

  _ModalContainerSlice.fromState(FireAtlasState state) : modal = state.modal;

  @override
  List<Object?> get props => [modal];
}

class ModalContainer extends StatelessWidget {
  const ModalContainer({super.key});

  @override
  Widget build(_) {
    return SliceWatcher<FireAtlasState, _ModalContainerSlice>(
      slicer: _ModalContainerSlice.fromState,
      builder: (ctx, store, slice) {
        final modal = slice.modal;
        if (modal != null) {
          return Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    color: Theme.of(ctx).dialogBackgroundColor.darken(0.8),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 10,
                bottom: 10,
                child: Center(
                  child: Opacity(
                    opacity: 1,
                    child: FContainer(
                      width: modal.width,
                      height: modal.height,
                      color: Theme.of(ctx).dialogBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: FIconButton(
                              iconData: Icons.close,
                              color: Theme.of(ctx).indicatorColor,
                              onPress: () {
                                store.dispatch(CloseEditorModal());
                              },
                            ),
                          ),
                          Expanded(child: modal.child),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Container(width: 0, height: 0);
      },
    );
  }
}
