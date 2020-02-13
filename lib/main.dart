import 'package:breaking_bapp/presentation/home_screen.dart';
import 'package:breaking_bapp/presentation/scene/character/detail/character_detail_page.dart';
import 'package:breaking_bapp/presentation/scene/character/list/character_list_page.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<Router>.value(
          value: Router()
            ..define(
              '/characters',
              transitionType: TransitionType.native,
              handler: Handler(
                handlerFunc: (context, _) => CharacterListPage(),
              ),
            )
            ..define(
              '/characters/:id',
              transitionType: TransitionType.native,
              handler: Handler(
                handlerFunc: (_, params) {
                  final id = int.parse(params['id'][0]);
                  return CharacterDetailPage(
                    id: id,
                  );
                },
              ),
            )
            ..define(
              '/quotes',
              transitionType: TransitionType.native,
              handler: Handler(
                handlerFunc: (context, _) => QuoteListPage(),
              ),
            )
            ..define(
              '/character',
              transitionType: TransitionType.nativeModal,
              handler: Handler(
                handlerFunc: (_, params) {
                  final name = params['name'][0];
                  return CharacterDetailPage(
                    name: name,
                  );
                },
              ),
            ),
        ),
        ProxyProvider<Router, RouteFactory>(
          update: (context, router, _) => router.generator,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Routing, navigation and deep linking sample',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeScreen(),
        onGenerateRoute: Provider.of<RouteFactory>(
          context,
          listen: false,
        ),
      );
}
