part of live_drawing_manager;

class LiveDrawingEvent extends DrawingEvent {
  const LiveDrawingEvent({
    required super.type,
    required super.offset,
    required this.senderId,
    required super.timestamp,
  });

  final int senderId;
}
