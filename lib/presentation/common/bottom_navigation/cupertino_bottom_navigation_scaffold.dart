import 'package:breaking_bapp/presentation/common/bottom_navigation/bottom_navigation_tab.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Detailed tutorial on this: https://edsonbueno.com/2020/01/23/bottom-navigation-in-flutter-mastery-guide/
class CupertinoBottomNavigationScaffold extends StatelessWidget {
  const CupertinoBottomNavigationScaffold({
    @required this.navigationBarItems,
    @required this.onItemSelected,
    @required this.selectedIndex,
    Key key,
  })  : assert(navigationBarItems != null),
        assert(onItemSelected != null),
        assert(selectedIndex != null),
        super(key: key);

  /// List of the tabs to be displayed with their respective navigator's keys.
  final List<BottomNavigationTab> navigationBarItems;

  /// Called when a tab selection occurs.
  final ValueChanged<int> onItemSelected;

  final int selectedIndex;

  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
        // As we're managing the selected index outside, there's no need
        // to make this Widget stateful. We just need pass the selectedIndex to
        // the controller every time the widget is rebuilt.
        controller: CupertinoTabController(initialIndex: selectedIndex),
        tabBar: CupertinoTabBar(
          items: navigationBarItems
              .map(
                (item) => item.bottomNavigationBarItem,
              )
              .toList(),
          onTap: onItemSelected,
        ),
        tabBuilder: (context, index) {
          final barItem = navigationBarItems[index];
          return CupertinoTabView(
            navigatorKey: barItem.navigatorKey,
            onGenerateRoute: (settings) {
              // The [Navigator] widget has a initialRoute parameter, which
              // enables us to define which route it should push as the initial
              // one. See [MaterialBottomNavigationScaffold] for more details.
              //
              // The problem is that in the Cupertino version, we're not
              // instantiating the [Navigator] ourselves, instead we're
              // delegating it to the CupertinoTabView, which doesn't provides
              // us with a way to set the initialRoute name. The best
              // alternative I could find is to "change" the route's name of
              // our RouteSettings to our BottomNavigationTab's initialRouteName
              // when the onGenerateRoute is being executed for the initial
              // route.
              var routeSettings = settings;
              if (settings.name == '/') {
                routeSettings =
                    settings.copyWith(name: barItem.initialRouteName);
              }

              return FluroRouter.appRouter
                  .matchRoute(
                    context,
                    routeSettings.name,
                    routeSettings: routeSettings,
                  )
                  .route;
            },
          );
        },
      );
}
