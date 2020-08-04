import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

class MicroStore<T> {
  T state;

  MicroStore(this.state);

  List<void Function(MicroStore<T>)> _listeners = [];

  void listen(void Function(MicroStore<T>) listener) {
    _listeners.add(listener);
  }

  void dispose(void Function(MicroStore<T>) listener) {
    _listeners.remove(listener);
  }

  void dispatch(MicroStoreAction<T> action) {
    action.store = this;
    state = action.perform(state);
    _notifyListeners();
  }

  Future<void> dispatchAsync(AsyncMicroStoreAction<T> action) async {
    action.store = this;
    state = await action.perform(state);
    _notifyListeners();
  }

  void _notifyListeners() {
    _listeners.forEach((l) => l.call(this));
  }
}

abstract class MicroStoreAction<T> {
  MicroStore<T> store;
  T perform(T state);
}

abstract class AsyncMicroStoreAction<T> {
  MicroStore<T> store;
  Future<T> perform(T state);
}

typedef MicroStoreProviderBuilder<T> = Widget Function(
    BuildContext, MicroStore<T>);
typedef MicroStoreProviderMemo<T> = List Function(MicroStore<T>);

class MicroStoreProvider<T> extends StatefulWidget {
  final MicroStore<T> store;
  final MicroStoreProviderBuilder<T> builder;
  final MicroStoreProviderMemo<T> memoFn;

  MicroStoreProvider({
    Key key,
    this.store,
    this.builder,
    this.memoFn,
  }) : super(key: key);

  @override
  State createState() => _MicroStoreProviderState<T>();
}

class _MicroStoreProviderState<T> extends State<MicroStoreProvider<T>> {
  MicroStore<T> _store;
  List _memoValue;

  void _update(MicroStore<T> store) {
    Function eq = const ListEquality().equals;

    List newMemo;
    if (widget.memoFn != null) {
      final newMemo = widget.memoFn(store);

      if (eq(newMemo, _memoValue)) {
        return;
      }
    }

    setState(() {
      _store = store;
      _memoValue = newMemo;
    });
  }

  @override
  void initState() {
    super.initState();

    _store = widget.store;
    _store.listen(_update);

    _memoValue = widget.memoFn?.call(_store);
  }

  @override
  void dispose() {
    super.dispose();
    _store.dispose(_update);
  }

  @override
  Widget build(context) => widget.builder(context, widget.store);
}
