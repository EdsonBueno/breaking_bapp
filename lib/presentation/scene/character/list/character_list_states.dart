import 'package:breaking_bapp/model/character_summary.dart';

abstract class CharacterListResponseState {}

class Success implements CharacterListResponseState {
  Success(this.list);

  final List<CharacterSummary> list;
}

class Loading implements CharacterListResponseState {}

class Error implements CharacterListResponseState {}
