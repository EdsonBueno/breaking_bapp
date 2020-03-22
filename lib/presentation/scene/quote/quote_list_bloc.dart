import 'dart:async';

import 'package:breaking_bapp/data_source.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_states.dart';
import 'package:rxdart/rxdart.dart';

class QuoteListBloc {
  QuoteListBloc() {
    _subscriptions
      ..add(
        _fetchQuoteList().listen(_onNewStateController.add),
      )
      ..add(
        _onTryAgainController.stream
            .flatMap((_) => _fetchQuoteList())
            .listen(_onNewStateController.add),
      );
  }

  final _subscriptions = CompositeSubscription();
  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onNewStateController = StreamController<QuoteListResponseState>();
  Stream<QuoteListResponseState> get onNewState => _onNewStateController.stream;

  Stream<QuoteListResponseState> _fetchQuoteList() async* {
    yield Loading();

    try {
      yield Success(
        await DataSource.getQuoteList(),
      );
    } catch (e) {
      yield Error();
    }
  }

  void dispose() {
    _onTryAgainController.close();
    _onNewStateController.close();
    _subscriptions.dispose();
  }
}
