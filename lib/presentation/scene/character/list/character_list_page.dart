import 'package:breaking_bapp/presentation/common/async_snapshot_response_view.dart';
import 'package:breaking_bapp/presentation/scene/character/detail/character_detail_page.dart';
import 'package:breaking_bapp/presentation/scene/character/list/character_list_bloc.dart';
import 'package:breaking_bapp/presentation/scene/character/list/character_list_item.dart';
import 'package:breaking_bapp/presentation/scene/character/list/character_list_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Fetches and displays a list of characters' summarized info.
class CharacterListPage extends StatefulWidget {
  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final _bloc = CharacterListBloc();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Characters'),
        ),
        body: StreamBuilder<CharacterListResponseState>(
          stream: _bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            onTryAgainTap: () => _bloc.onTryAgain.add(null),
            contentWidgetBuilder: (context, successState) {
              final characterSummaryList = successState.list;
              return ListView.builder(
                itemCount: characterSummaryList.length,
                itemBuilder: (context, index) {
                  final character = characterSummaryList[index];
                  return CharacterListItem(
                    character: character,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterDetailPage(
                            id: character.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
