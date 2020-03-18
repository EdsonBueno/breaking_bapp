import 'dart:async';

import 'package:breaking_bapp/data_source.dart';
import 'package:breaking_bapp/presentation/scene/character/list/character_list_states.dart';
import 'package:rxdart/rxdart.dart';

class CharacterListBloc {
  CharacterListBloc() {
    _subscriptions.add(
      Rx.merge([
        _onFocusGainedSubject.stream,
        _onTryAgainSubject.stream,
      ])
          .flatMap(
            (_) => _fetchCharacterSummaryList(),
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

  final _onNewStateSubject = BehaviorSubject<CharacterListResponseState>();
  Stream<CharacterListResponseState> get onNewState => _onNewStateSubject;

  Stream<CharacterListResponseState> _fetchCharacterSummaryList() async* {
    yield Loading();

    try {
      yield Success(
        await DataSource.getCharacterList(),
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
