const _step = Duration(milliseconds: 100);

/// Callback for [GlitchIterableX.tick].
typedef OnTick = void Function(int index, Duration duration);

/// Extension for [Iterable].
extension GlitchIterableX<T> on Iterable<T> {
  /// It is used to iterate over an [Iterable] and call [onTick] for each element
  /// with a [Duration] that is a multiple of [interval].
  void tick(OnTick onTick, {Duration interval = _step}) {
    for (var i = 0; i < length; i++) {
      final elementNumber = i + 1;
      final duration = interval * elementNumber;

      onTick(i, duration);
    }
  }
}
