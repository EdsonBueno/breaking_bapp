import 'dart:async';

import 'package:breaking_bapp/data_source.dart';
import 'package:breaking_bapp/presentation/scene/character/detail/character_detail_states.dart';
import 'package:rxdart/rxdart.dart';

class CharacterDetailBloc {
  CharacterDetailBloc({
    this.characterId,
    this.characterName,
  }) : assert(characterId != null || characterName != null) {
    _subscriptions
      ..add(
        _fetchCharacterDetail().listen(_onNewStateSubject.add),
      )
      ..add(
        _onTryAgainSubject.stream
            .flatMap((_) => _fetchCharacterDetail())
            .listen(_onNewStateSubject.add),
      );
  }

  final int characterId;
  final String characterName;

  final _subscriptions = CompositeSubscription();
  final _onTryAgainSubject = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  final _onNewStateSubject = BehaviorSubject<CharacterDetailResponseState>();
  Stream<CharacterDetailResponseState> get onNewState => _onNewStateSubject;

  Stream<CharacterDetailResponseState> _fetchCharacterDetail() async* {
    yield Loading();

    try {
      yield Success(
        await DataSource.getCharacterDetail(
          id: characterId,
          name: characterName,
        ),
      );
    } catch (e) {
      yield Error();
    }
  }

  void dispose() {
    _onTryAgainSubject.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
