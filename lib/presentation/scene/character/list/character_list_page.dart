import 'package:breaking_bapp/presentation/common/async_snapshot_response_view.dart';
import 'package:breaking_bapp/presentation/route_name_builder.dart';
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
        body: StreamBuilder(
          stream: _bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            onTryAgainTap: () => _bloc.onTryAgain.add(null),
            successWidgetBuilder: (context, successState) {
              final characterSummaryList = successState.list;
              return ListView.builder(
                itemCount: characterSummaryList.length,
                itemBuilder: (context, index) {
                  final character = characterSummaryList[index];
                  return CharacterListItem(
                    character: character,
                    onTap: () {
                      // Detailed tutorial on this:
                      // https://edsonbueno.com/2020/02/26/spotless-routing-and-navigation-in-flutter/
                      Navigator.of(context).pushNamed(
                        RouteNameBuilder.characterById(
                          character.id,
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
