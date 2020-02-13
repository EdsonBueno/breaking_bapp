/// Provides functions for building our route names and exposes the used
/// resource paths.
class RouteNameBuilder {
  static const charactersResource = 'characters';
  static const quotesResource = 'quotes';
  static const authorsResource = 'authors';
  static const authorNameQueryParameterName = 'name';

  static String characterList() => '$charactersResource';

  static String characterById(int id) => '$charactersResource/$id';

  static String quoteAuthorByName(String name) =>
      '$quotesResource/$authorsResource?'
      '$authorNameQueryParameterName=$name';

  static String quoteList() => '$quotesResource';
}
