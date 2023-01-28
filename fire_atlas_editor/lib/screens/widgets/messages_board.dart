import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/color_badge.dart';
import 'package:fire_atlas_editor/widgets/slide_container.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class _MessageBoardSlice extends Equatable {
  final List<Message> messages;

  _MessageBoardSlice.fromState(FireAtlasState state)
      : messages = state.messages.toList();

  @override
  List<Object?> get props => [messages];
}

class MessagesBoard extends StatelessWidget {
  const MessagesBoard({Key? key}) : super(key: key);

  @override
  Widget build(_) {
    return SliceWatcher<FireAtlasState, _MessageBoardSlice>(
      slicer: (state) => _MessageBoardSlice.fromState(state),
      builder: (ctx, store, slice) {
        return Column(
          children: slice.messages
              .map((message) {
                return _Message(
                  key: Key(message.message),
                  message: message,
                  onVanish: () {
                    store.dispatch(DismissMessageAction(message: message));
                  },
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  final Message message;
  final VoidCallback onVanish;

  const _Message({
    required this.message,
    required this.onVanish,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final color = message.type == MessageType.INFO
        ? const Color(0xFF34b4eb)
        : Theme.of(ctx).colorScheme.error;

    return SlideContainer(
      key: key,
      curve: Curves.easeOutQuad,
      onFinish: (controller) {
        Future<void>.delayed(const Duration(milliseconds: 2500)).then((_) {
          controller.reverse().whenComplete(onVanish);
        });
      },
      from: const Offset(1.2, 0.0),
      child: ColorBadge(
        color: color,
        label: message.message,
      ),
    );
  }
}
