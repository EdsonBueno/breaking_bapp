import 'package:breaking_bapp/presentation/common/centered_progress_indicator.dart';
import 'package:breaking_bapp/presentation/common/error_indicator.dart';
import 'package:breaking_bapp/presentation/route_name_builder.dart';
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
        body: StreamBuilder(
          stream: _bloc.onNewState,
          builder: (context, snapshot) {
            final snapshotData = snapshot.data;
            if (snapshotData == null || snapshotData is Loading) {
              return CenteredProgressIndicator();
            }

            if (snapshotData is Success) {
              final quoteList = snapshotData.list;
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
            }

            return ErrorIndicator(
              onActionButtonPressed: () => _bloc.onTryAgain.add(null),
            );
          },
        ),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
