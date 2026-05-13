/// Mirrors plan-12 status chips (local DB / sync).
enum OrderLocalStatus {
  newOrder,
  inProgress,
  ready,
  delivered,
  cancelled,
}

extension OrderLocalStatusCode on OrderLocalStatus {
  int get code => index;
}

OrderLocalStatus orderStatusFromCode(int code) {
  final i = code.clamp(0, OrderLocalStatus.values.length - 1);
  return OrderLocalStatus.values[i];
}
