import 'package:flutter/widgets.dart';

class MicroStore<T> {
  T state;

  List<void Function(MicroStore<T>)> _listeners = [];

  void listen(void Function(MicroStore<T>) listener) {
    _listeners.add(listener);
  }

  void dispose(void Function(MicroStore<T>) listener) {
    _listeners.remove(listener);
  }

  void setState(T Function(T) fn) {
    state = fn(state);
    _listeners.forEach((l) => l.call(this));
  }
}

class MicroStoreProvider<T> extends StatefulWidget {
  final MicroStore<T> store;
  final Widget child;

  MicroStoreProvider({
    Key key,
    this.store,
    this.child,
  }): super(key: key);

  @override
  State createState() => _MicroStoreProviderState();
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
  Widget build(context) => widget.child;
}
