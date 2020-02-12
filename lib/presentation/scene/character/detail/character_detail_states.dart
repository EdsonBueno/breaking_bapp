import 'package:breaking_bapp/model/character_detail.dart';

abstract class CharacterDetailResponseState {}

class Success implements CharacterDetailResponseState {
  Success(this.character);

  final CharacterDetail character;
}

class Loading implements CharacterDetailResponseState {}

class Error implements CharacterDetailResponseState {}
