import 'package:breaking_bapp/presentation/common/response_view.dart';
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
        body: StreamBuilder<CharacterListState>(
          stream: _bloc.onNewState,
          builder: (context, snapshot) {
            final state = snapshot.data;
            return ResponseView(
              isLoading: state is Loading,
              hasError: state is Error,
              onTryAgainTap: () => _bloc.onTryAgain.add(null),
              contentWidgetBuilder: (context) {
                if (state is Success) {
                  final characterSummaryList = state.list;
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
                } else {
                  return Container();
                }
              },
            );
          },
        ),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
