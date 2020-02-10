import 'package:flutter/widgets.dart';

/// Contains the necessary parameters for building a
/// [BottomNavigationScaffold].
/// Detailed tutorial: https://edsonbueno.com/2020/01/23/bottom-navigation-in-flutter-mastery-guide/
class BottomNavigationTab {
  const BottomNavigationTab({
    @required this.bottomNavigationBarItem,
    @required this.navigatorKey,
    @required this.initialPageBuilder,
  })  : assert(bottomNavigationBarItem != null),
        assert(navigatorKey != null),
        assert(initialPageBuilder != null);

  final BottomNavigationBarItem bottomNavigationBarItem;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget Function(BuildContext context) initialPageBuilder;
}
