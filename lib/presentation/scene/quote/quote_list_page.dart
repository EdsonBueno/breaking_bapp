import 'package:breaking_bapp/data_source.dart';
import 'package:breaking_bapp/model/quote.dart';
import 'package:breaking_bapp/presentation/common/response_view.dart';
import 'package:breaking_bapp/presentation/route_name_builder.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Fetches and displays a list of popular quotes.
class QuoteListPage extends StatefulWidget {
  @override
  _QuoteListPageState createState() => _QuoteListPageState();
}

// We're using `setState` as the state management approach to keep it as
// basic as possible and avoid taking the focus off the routing/navigation,
// which is the purpose of this tutorial.
class _QuoteListPageState extends State<QuoteListPage> {
  /// An object that identifies the currently active Future call. Used to avoid
  /// calling setState under two conditions:
  /// 1 - If this state is already disposed, e.g. if the user left this page
  /// before the Future completion.
  /// 2 - From duplicated Future calls, if somehow we call
  /// _fetchQuoteList two times in a row.
  Object _activeCallbackIdentity;

  List<Quote> _quoteList;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    _fetchQuoteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Quotes'),
        ),
        body: ResponseView(
          isLoading: _isLoading,
          hasError: _hasError,
          onTryAgainTap: _fetchQuoteList,
          contentWidgetBuilder: (context) => ListView.separated(
            itemCount: _quoteList.length,
            itemBuilder: (context, index) {
              final quote = _quoteList[index];
              return QuoteListItem(
                quote: quote,
                onAuthorNameTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    RouteNameBuilder.quoteAuthorByName(
                      quote.authorName,
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      );

  @override
  void dispose() {
    _activeCallbackIdentity = null;
    super.dispose();
  }

  Future<void> _fetchQuoteList() async {
    setState(() {
      _isLoading = true;
    });

    final callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;

    try {
      final fetchedQuoteList = await DataSource.getQuoteList();
      if (callbackIdentity == _activeCallbackIdentity) {
        setState(() {
          _quoteList = fetchedQuoteList;
          _isLoading = false;
          _hasError = false;
        });
      }
    } on Exception {
      if (callbackIdentity == _activeCallbackIdentity) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }
}
