import 'package:flutter/widgets.dart';

class SlicesStore<T> {
  T state;

  SlicesStore(this.state);

  List<void Function(SlicesStore<T>)> _listeners = [];

  void listen(void Function(SlicesStore<T>) listener) {
    _listeners.add(listener);
  }

  void dispose(void Function(SlicesStore<T>) listener) {
    _listeners.remove(listener);
  }

  void dispatch(SlicesAction<T> action) {
    action.store = this;
    state = action.perform(state);
    _notifyListeners();
  }

  Future<void> dispatchAsync(AsyncSlicesAction<T> action) async {
    action.store = this;
    state = await action.perform(state);
    _notifyListeners();
  }

  void _notifyListeners() {
    _listeners.forEach((l) => l.call(this));
  }
}

abstract class SlicesAction<T> {
  late SlicesStore<T> store;
  T perform(T state);
}

abstract class AsyncSlicesAction<T> {
  late SlicesStore<T> store;
  Future<T> perform(T state);
}

class SlicesProvider<T> extends InheritedWidget {
  final SlicesStore<T> store;

  SlicesProvider({
    Key? key,
    required this.store,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(SlicesProvider old) => store != old.store;

  static SlicesStore<S> of<S>(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<SlicesProvider<S>>();

    if (widget == null) {
      throw 'No SlicesProvider available on the tree';
    }

    return widget.store;
  }
}

typedef SlicerFn<T, S> = S Function(T);

typedef SliceWatcherBuilder<T, S> = Widget Function(
    BuildContext, SlicesStore<T>, S);

class SliceWatcher<T, S> extends StatefulWidget {
  final SliceWatcherBuilder<T, S> builder;
  final SlicerFn<T, S> slicer;

  SliceWatcher({
    Key? key,
    required this.builder,
    required this.slicer,
  }) : super(key: key);

  @override
  State createState() => _SliceWatcherState<T, S>();
}

class _SliceWatcherState<T, S> extends State<SliceWatcher<T, S>> {
  late SlicesStore<T> _store;
  late S _memoValue;

  void _update(SlicesStore<T> store) {
    S newMemo = widget.slicer(store.state);

    if (newMemo == _memoValue) {
      return;
    }

    setState(() {
      _store = store;
      _memoValue = newMemo;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _store = SlicesProvider.of<T>(context);
    _store.listen(_update);

    _memoValue = widget.slicer.call(_store.state);
  }

  @override
  void dispose() {
    super.dispose();
    _store.dispose(_update);
  }

  @override
  Widget build(context) => widget.builder(context, _store, _memoValue);
}
