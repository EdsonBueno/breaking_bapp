import 'package:breaking_bapp/data_source.dart';
import 'package:breaking_bapp/model/quote.dart';
import 'package:breaking_bapp/presentation/common/response_view.dart';
import 'package:breaking_bapp/presentation/route_name_builder.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:focus_detector/focus_detector.dart';

/// Fetches and displays a list of popular quotes.
class QuoteListPage extends StatefulWidget {
  @override
  _QuoteListPageState createState() => _QuoteListPageState();
}

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

  // Vital for identifying our FocusDetector when a rebuild occurs.
  final Key focusDetectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: focusDetectorKey,
        onFocusGained: _fetchQuoteList,
        child: Scaffold(
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
                    // Detailed tutorial on this:
                    // https://edsonbueno.com/2020/02/26/spotless-routing-and-navigation-in-flutter/
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
