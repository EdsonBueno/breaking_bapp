import 'package:breaking_bapp/data_source.dart';
import 'package:breaking_bapp/model/character_summary.dart';
import 'package:breaking_bapp/presentation/common/response_view.dart';
import 'package:breaking_bapp/presentation/scene/list/character_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Fetches and displays a list of characters' summarized info.
class CharacterListPage extends StatefulWidget {
  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  List<CharacterSummary> _characterSummaryList;
  bool _isLoading = true;
  bool _hasError = false;

  Future<void> _fetchCharacterSummaryList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedCharacterList = await DataSource.getCharacterList();
      setState(() {
        _characterSummaryList = fetchedCharacterList;
        _isLoading = false;
        _hasError = false;
      });
    } on Exception {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _fetchCharacterSummaryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Characters'),
        ),
        body: ResponseView(
          isLoading: _isLoading,
          hasError: _hasError,
          onTryAgainTap: _fetchCharacterSummaryList,
          contentWidgetBuilder: (context) => ListView.builder(
            itemCount: _characterSummaryList.length,
            itemBuilder: (context, index) => CharacterListItem(
              character: _characterSummaryList[index],
              onTap: (id) {
                /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterDetailPage(id: id),
              ),
            );
            */
              },
            ),
          ),
        ),
      );
}
