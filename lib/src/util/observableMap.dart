class ObservableMap<T, U> {
  Map<T, U> _map = {};
  String _debugName;

  ObservableMap(String debugName, [Map<T, U> other]) {
    _debugName = debugName;
    _map = other != null ? other : {};
  }

  factory ObservableMap.from(ObservableMap<T, U> other) {
    return ObservableMap(other._debugName, Map.from(other._map));
  }

  U operator [](T key) {
    return _map[key];
  }

  operator []=(T key, U value) {
    print("   Set $_debugName $key $value");
    _map[key] = value;
  }

  int get length => _map.length;

  @override
  String toString() => _map.toString();

  List<T> toList() => _map.keys.toList();

  Iterable<T> get keys => _map.keys;
}
