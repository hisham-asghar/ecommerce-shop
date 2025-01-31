import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// An in-memory store backed by BehaviorSubject that can be used to
/// store the data for all the fake repositories in the app.
class InMemoryStore<T> {
  InMemoryStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);
  // The BehaviorSubject that holds the data
  final BehaviorSubject<T> _subject;
  // The output stream that can be used to listen to the data
  Stream<T> get stream => _subject.stream;

  // A synchronous getter for the current value
  T get value => _subject.value;
  // A setter for updating the data
  set value(T value) {
    _subject.add(value);
  }

  void close() => _subject.close();
}
