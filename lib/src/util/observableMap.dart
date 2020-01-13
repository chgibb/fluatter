class ObservableMap<T, U> {
  Map<T, U> _map = {};

  ObservableMap([Map<T, U> other]) {
    _map = other != null ? other : {};
  }

  factory ObservableMap.from(ObservableMap<T, U> other) {
    return ObservableMap(Map.from(other._map));
  }

  U operator [](T key) {
    return _map[key];
  }

  operator []=(T key, U value) {
    print("   Set $key $value");
    _map[key] = value;
  }
}
