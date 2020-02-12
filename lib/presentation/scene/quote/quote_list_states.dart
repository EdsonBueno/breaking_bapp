import 'package:breaking_bapp/model/quote.dart';

abstract class QuoteListResponseState {}

class Success implements QuoteListResponseState {
  Success(this.list);

  final List<Quote> list;
}

class Loading implements QuoteListResponseState {}

class Error implements QuoteListResponseState {}
