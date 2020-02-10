import 'package:breaking_bapp/presentation/common/bottom_navigation/bottom_navigation_scaffold.dart';
import 'package:breaking_bapp/presentation/common/bottom_navigation/bottom_navigation_tab.dart';
import 'package:breaking_bapp/presentation/scene/list/character_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => BottomNavigationScaffold(
        navigationBarItems: [
          BottomNavigationTab(
            bottomNavigationBarItem: BottomNavigationBarItem(
              title: const Text('Characters'),
              icon: Icon(Icons.people),
            ),
            navigatorKey: GlobalKey<NavigatorState>(),
            initialPageBuilder: () => CharacterListPage(),
          ),
          BottomNavigationTab(
            bottomNavigationBarItem: BottomNavigationBarItem(
              title: const Text('Quotes'),
              icon: Icon(Icons.format_quote),
            ),
            navigatorKey: GlobalKey<NavigatorState>(),
            initialPageBuilder: () => Container(),
          )
        ],
      );
}
