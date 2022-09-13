part of live_drawing_manager;

abstract class LiveDrawingManager<T extends LiveDrawingEvent>
    extends DrawingManager<T> {
  LiveDrawingManager(
      super.paint,
      this._senderId,
      this._channel, {
        Function? onError = _defaultErrorHandler,
        VoidCallback? onDone = _defaultDoneHandler,
      }) {
    _channel.stream.listen(
      _onEvent,
      onDone: onDone,
      onError: onError,
    );
  }

  T deserializeEvent(dynamic event);

  dynamic serializeEvent(T t);

  @override
  void addDrawingEvent(T event) {
    if (_lastTimestamp == event.timestamp) return;
    _lastTimestamp = event.timestamp;

    super.addDrawingEvent(event);
    if (_senderId == event.senderId) {
      _channel.sink.add(serializeEvent(event));
    }
  }

  void _onEvent(event) => addDrawingEvent(deserializeEvent(event));

  final IOWebSocketChannel _channel;
  final int _senderId;
  int? _lastTimestamp;
}

void _defaultDoneHandler() {
  debugPrint('Stream is ended');
}

void _defaultErrorHandler(Error error) {
  assert(() {
    // TODO(ArishSultan): Throw Proper Flutter Error.
    return true;
  }());

  debugPrintStack(stackTrace: error.stackTrace, label: error.toString());
}
