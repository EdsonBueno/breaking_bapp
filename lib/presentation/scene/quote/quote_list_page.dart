import 'package:breaking_bapp/presentation/common/async_snapshot_response_view.dart';
import 'package:breaking_bapp/presentation/route_name_builder.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_bloc.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_item.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:focus_detector/focus_detector.dart';

/// Fetches and displays a list of popular quotes.
class QuoteListPage extends StatefulWidget {
  @override
  _QuoteListPageState createState() => _QuoteListPageState();
}

class _QuoteListPageState extends State<QuoteListPage> {
  final _bloc = QuoteListBloc();
  final _focusDetectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () => _bloc.onFocusGained.add(null),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quotes'),
          ),
          body: StreamBuilder(
            stream: _bloc.onNewState,
            builder: (context, snapshot) =>
                AsyncSnapshotResponseView<Loading, Error, Success>(
              snapshot: snapshot,
              onTryAgainTap: () => _bloc.onTryAgain.add(null),
              successWidgetBuilder: (context, successState) {
                final quoteList = successState.list;
                return ListView.separated(
                  itemCount: quoteList.length,
                  itemBuilder: (context, index) {
                    final quote = quoteList[index];
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
                );
              },
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
