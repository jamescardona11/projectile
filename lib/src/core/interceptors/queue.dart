import 'dart:async';
import 'dart:collection';

typedef Closure<T> = Future<T> Function(T value);

//REF https://stackoverflow.com/questions/62878704/how-to-implement-an-async-task-queue-with-multiple-concurrent-workers-async-in

/// {@template queue}
/// {@endtemplate}
abstract class IQueue<T> {
  Future<T> run(T initialData);

  void add(Closure<T> closure);

  void addAll(List<Closure<T>> closures);

  void clear();
}

class FutureQueue<T> implements IQueue<T> {
  final Queue<_QueueItem<T>> _nextCycle = Queue();
  // final List<_QueueItem<T>> _nextCycle = [];

  @override
  void add(Closure<T> closure) {
    _nextCycle.add(_QueueItem<T>(closure));
  }

  @override
  void addAll(Iterable<Closure<T>> closures) {
    _nextCycle.addAll(closures.map((e) => _QueueItem<T>(e)));
  }

  /// Verify in the future that queue its no running
  @override
  void clear() {
    _nextCycle.clear();
  }

  @override
  Future<T> run(T initialData) async {
    T data = initialData;
    final processCompleter = Completer<T>();

    Future.doWhile(() async {
      data = await _process(data);

      if (_nextCycle.isEmpty) {
        processCompleter.complete(data);
      }

      return _nextCycle.isNotEmpty;
    });

    return processCompleter.future;
  }

  Future<T> _process(T data) async {
    if (_nextCycle.isEmpty) {
      return data;
    }

    final item = _nextCycle.removeFirst();
    final completer = item.completer;
    item.execute(data);

    return completer.future;
  }
}

class _QueueItem<T> {
  _QueueItem(
    this.closure,
  );

  final Closure<T> closure;
  final Completer<T> completer = Completer<T>();

  Future<void> execute(T data) async {
    T result;
    try {
      result = await closure.call(data);
      completer.complete(result);
      await Future.microtask(() {});
    } catch (e) {
      // todo create a interceptor failure
      // change por completer
      completer.completeError(e);
    }
  }
}
