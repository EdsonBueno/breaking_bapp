import 'package:breaking_bapp/presentation/common/bottom_navigation/bottom_navigation_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A Scaffold with a configured BottomNavigationBar, separate
/// Navigators for each tab view and state retaining across tab switches.
/// Detailed tutorial: https://edsonbueno.com/2020/01/23/bottom-navigation-in-flutter-mastery-guide/
class BottomNavigationScaffold extends StatefulWidget {
  const BottomNavigationScaffold({
    @required this.navigationBarItems,
    this.onItemSelected,
    Key key,
  })  : assert(navigationBarItems != null),
        super(key: key);

  /// List of the tabs to be displayed with their respective navigator's keys
  /// and initial page builders.
  final List<BottomNavigationTab> navigationBarItems;

  final ValueChanged<int> onItemSelected;

  @override
  _BottomNavigationScaffoldState createState() =>
      _BottomNavigationScaffoldState();
}

class _BottomNavigationScaffoldState extends State<BottomNavigationScaffold> {
  int _currentlySelectedIndex = 0;

  @override
  Widget build(BuildContext context) => WillPopScope(
        // We're preventing the root navigator from popping and closing the app
        // when the back button is pressed and the inner navigator can handle
        // it. That occurs when the inner has more than one page on its stack.
        // You can comment the onWillPop callback and watch "the bug".
        onWillPop: () async => !await widget
            .navigationBarItems[_currentlySelectedIndex]
            .navigatorKey
            .currentState
            .maybePop(),
        child: Scaffold(
          // The IndexedStack is what allows us to retain state across tab
          // switches by keeping our views in the widget tree while only showing
          // the selected one.
          body: IndexedStack(
            index: _currentlySelectedIndex,
            children: widget.navigationBarItems
                .map(
                  (item) => Navigator(
                    key: item.navigatorKey,
                    onGenerateRoute: (settings) => MaterialPageRoute(
                      settings: settings,
                      builder: (context) => item.initialPageBuilder(context),
                    ),
                  ),
                )
                .toList(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentlySelectedIndex,
            items: widget.navigationBarItems
                .map(
                  (item) => item.bottomNavigationBarItem,
                )
                .toList(),
            onTap: onTabSelected,
          ),
        ),
      );

  /// Called when a tab selection occurs.
  void onTabSelected(int newIndex) {
    if (_currentlySelectedIndex == newIndex) {
      // If the user is re-selecting the tab, the common
      // behavior is to empty the stack.
      widget.navigationBarItems[newIndex].navigatorKey.currentState.popUntil(
        (route) => route.isFirst,
      );
    } else {
      setState(() {
        _currentlySelectedIndex = newIndex;
      });
    }

    if (widget.onItemSelected != null) {
      widget.onItemSelected(newIndex);
    }
  }
}
