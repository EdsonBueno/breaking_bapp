import 'dart:async';

import 'package:breaking_bapp/data_source.dart';
import 'package:breaking_bapp/presentation/scene/quote/quote_list_states.dart';
import 'package:rxdart/rxdart.dart';

class QuoteListBloc {
  QuoteListBloc() {
    _subscriptions.add(
      Rx.merge([
        _onFocusGainedSubject.stream,
        _onTryAgainSubject.stream,
      ])
          .flatMap(
            (_) => _fetchQuoteList(),
          )
          .listen(
            _onNewStateSubject.add,
          ),
    );
  }

  final _subscriptions = CompositeSubscription();

  final _onTryAgainSubject = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  final _onFocusGainedSubject = StreamController<void>();
  Sink<void> get onFocusGained => _onFocusGainedSubject.sink;

  final _onNewStateSubject = BehaviorSubject<QuoteListResponseState>();
  Stream<QuoteListResponseState> get onNewState => _onNewStateSubject;

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
    _onTryAgainSubject.close();
    _onNewStateSubject.close();
    _onFocusGainedSubject.close();
    _subscriptions.dispose();
  }
}
