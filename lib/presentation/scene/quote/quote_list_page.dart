import 'package:breaking_bapp/data_source.dart';
import 'package:breaking_bapp/model/quote.dart';
import 'package:breaking_bapp/presentation/common/response_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Fetches and displays a list of popular quotes.
class QuoteListPage extends StatefulWidget {
  @override
  _QuoteListPageState createState() => _QuoteListPageState();
}

class _QuoteListPageState extends State<QuoteListPage> {
  List<Quote> _quoteList;
  bool _isLoading = true;
  bool _hasError = false;

  Future<void> _fetchQuoteList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedQuoteList = await DataSource.getQuoteList();
      setState(() {
        _quoteList = fetchedQuoteList;
        _isLoading = false;
        _hasError = false;
      });
    } on Exception {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

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
          contentWidgetBuilder: (context) => ListView.builder(
            itemCount: _quoteList.length,
            itemBuilder: (context, index) => Text(_quoteList[index].text),
          ),
        ),
      );
}
