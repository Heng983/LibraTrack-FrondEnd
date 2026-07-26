import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int index) => state = index;
}

final mainTabIndexProvider = NotifierProvider<NavIndexNotifier, int>(
  NavIndexNotifier.new,
);

final adminTabIndexProvider = NotifierProvider<NavIndexNotifier, int>(
  NavIndexNotifier.new,
);

/// Set by other screens (e.g. the dashboard notification sheet) to ask the
/// admin RequestScreen to jump to a specific tab. RequestScreen listens,
/// applies the tab, then clears it back to null.
class RequestScreenTabNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void request(int tab) => state = tab;
  void clear() => state = null;
}

final requestScreenTabProvider = NotifierProvider<RequestScreenTabNotifier, int?>(
  RequestScreenTabNotifier.new,
);
