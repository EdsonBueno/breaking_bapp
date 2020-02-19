import 'package:breaking_bapp/presentation/home_screen.dart';
import 'package:breaking_bapp/presentation/scene/character/detail/character_detail_page.dart';
import 'package:breaking_bapp/presentation/scene/character/list/character_list_page.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

void main() {
  Router.appRouter
    // The '..' syntax is a Dart feature called cascade notation.
    // Further reading: https://dart.dev/guides/language/language-tour#cascade-notation-
    ..define(
      '/',
      // Handler is a custom Fluro's class, in which you define the route's
      // widget builder as the Handler.handlerFunc.
      handler: Handler(
        handlerFunc: (context, params) => HomeScreen(),
      ),
    )
    ..define(
      RouteNameBuilder.charactersResource,
      'characters',
      handler: Handler(
        handlerFunc: (context, params) => CharacterListPage(),
      ),
    )
    ..define(
      '${RouteNameBuilder.charactersResource}/:id',
      // The ':id' syntax is how we tell Fluro to parse whatever comes in
      // that location and give it a name of 'id'.
      'characters/:id',
      transitionType: TransitionType.native,
      handler: Handler(
        handlerFunc: (context, params) {
          // The 'params' is a dictionary where the key is the name we gave to
          // the parameter ('id' in this case), and the value is an array with
          // all the arguments that were provided (just a single `int` in this
          // case). Fluro gives us an array as the value instead of a single
          // item because when we're working with query string parameters,
          // we're able to pass an array as the argument, such as
          // '?name=Jesse,Walter,Gus'.
          final id = int.parse(params['id'][0]);
          return CharacterDetailPage(
            id: id,
          );
        },
      ),
    )
    ..define(
      RouteNameBuilder.quotesResource,
      'quotes',
      handler: Handler(
        handlerFunc: (context, params) => QuoteListPage(),
      ),
    )
    ..define(
        '${RouteNameBuilder.quotesResource}/${RouteNameBuilder.authorsResource}',
      'quotes/authors',
      // You can customize the transition type for every route.
      transitionType: TransitionType.nativeModal,
      handler: Handler(
        handlerFunc: (context, params) {
          // We extract an expected query string parameter just as we did with
          // the 'id' in the third route definition. The only difference being
          // that with query parameters we don't need to specify it in the
          // route path ('quotes/authors' in this case).
          final name = params['name'][0];
          return CharacterDetailPage(
            name: name,
          );
        },
      ),
    );

  runApp(
    MyApp(),
  );
}

// This is the definition of the MyApp Widget, which can be found
// at the main.dart file. Notice the MaterialApp's onGenerateRoute constructor
// parameter. It's a function that receives a RouteSettings object, which
// contains information about the route we're intending to navigate to, and
// expects us to return a concrete Route.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Routing, navigation and deep linking sample',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        onGenerateRoute: Router.appRouter.generator,
      );
}
