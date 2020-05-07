import 'package:flutter/widgets.dart';

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
    _listeners.forEach((l) => l.call(this));
  }
}

abstract class MicroStoreAction<T> {
  MicroStore<T> store;
  T perform(T state);
}

typedef MicroStoreProviderBuilder<T> = Widget Function(BuildContext, MicroStore<T>);

class MicroStoreProvider<T> extends StatefulWidget {
  final MicroStore<T> store;
  final MicroStoreProviderBuilder<T> builder;

  MicroStoreProvider({
    Key key,
    this.store,
    this.builder,
  }): super(key: key);

  @override
  State createState() => _MicroStoreProviderState<T>();
}

class _MicroStoreProviderState<T> extends State<MicroStoreProvider<T>> {
  MicroStore<T> _store;

  void _update(MicroStore<T> store) {
    setState(() {
      _store = store;
    });
  }

  @override
  void initState() {
    super.initState();

    _store = widget.store;
    _store.listen(_update);
  }

  @override
  void dispose() {
    super.dispose();
    _store.dispose(_update);
  }

  @override
  Widget build(context) => widget.builder(context, widget.store);
}
