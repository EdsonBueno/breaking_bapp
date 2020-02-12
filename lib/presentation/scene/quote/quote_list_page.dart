import 'package:breaking_bapp/presentation/common/async_snapshot_response_view.dart';
import 'package:breaking_bapp/presentation/scene/character/detail/character_detail_page.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_bloc.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_item.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Fetches and displays a list of popular quotes.
class QuoteListPage extends StatefulWidget {
  @override
  _QuoteListPageState createState() => _QuoteListPageState();
}

class _QuoteListPageState extends State<QuoteListPage> {
  final _bloc = QuoteListBloc();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Quotes'),
        ),
        body: StreamBuilder<QuoteListResponseState>(
          stream: _bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            onTryAgainTap: () => _bloc.onTryAgain.add(null),
            contentWidgetBuilder: (context, successState) {
              final quoteList = successState.list;
              return ListView.separated(
                itemCount: quoteList.length,
                itemBuilder: (context, index) {
                  final quote = quoteList[index];
                  return QuoteListItem(
                    quote: quote,
                    onAuthorNameTap: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => CharacterDetailPage(
                            name: quote.authorName,
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            },
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
