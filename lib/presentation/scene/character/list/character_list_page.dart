import 'package:breaking_bapp/presentation/common/centered_progress_indicator.dart';
import 'package:breaking_bapp/presentation/common/error_indicator.dart';
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
          builder: (context, snapshot) {
            final snapshotData = snapshot.data;
            if (snapshotData == null || snapshotData is Loading) {
              return CenteredProgressIndicator();
            }

            if (snapshotData is Success) {
              return ListView.builder(
                itemCount: snapshotData.list.length,
                itemBuilder: (context, index) {
                  final character = snapshotData.list[index];
                  return CharacterListItem(
                    character: character,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RouteNameBuilder.characterById(
                          character.id,
                        ),
                      );
                    },
                  );
                },
              );
            }

            return ErrorIndicator(
              onActionButtonPressed: () => _bloc.onTryAgain.add(null),
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
