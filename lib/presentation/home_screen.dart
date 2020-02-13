import 'package:breaking_bapp/presentation/common/bottom_navigation/adaptive_bottom_navigation_scaffold.dart';
import 'package:breaking_bapp/presentation/common/bottom_navigation/bottom_navigation_tab.dart';
import 'package:breaking_bapp/presentation/scene/character/list/character_list_page.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<BottomNavigationTab> _bottomNavigationTabs = [
    BottomNavigationTab(
      bottomNavigationBarItem: BottomNavigationBarItem(
        title: const Text('Characters'),
        icon: Icon(Icons.people),
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      initialPageBuilder: (_) => CharacterListPage(),
    ),
    BottomNavigationTab(
      bottomNavigationBarItem: BottomNavigationBarItem(
        title: const Text('Quotes'),
        icon: Icon(Icons.format_quote),
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      initialPageBuilder: (_) => QuoteListPage(),
    )
  ];

  @override
  Widget build(BuildContext context) => AdaptiveBottomNavigationScaffold(
        navigationBarItems: _bottomNavigationTabs,
      );
}
