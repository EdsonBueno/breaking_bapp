import 'package:breaking_bapp/model/character_summary.dart';

abstract class CharacterListState {}

class Success extends CharacterListState {
  Success(this.list);

  final List<CharacterSummary> list;
}

class Loading extends CharacterListState {}

class Error extends CharacterListState {}
