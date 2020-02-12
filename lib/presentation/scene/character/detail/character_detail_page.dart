import 'package:breaking_bapp/presentation/common/async_snapshot_response_view.dart';
import 'package:breaking_bapp/presentation/common/labeled_text.dart';
import 'package:breaking_bapp/presentation/scene/character/detail/character_detail_bloc.dart';
import 'package:breaking_bapp/presentation/scene/character/detail/character_detail_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Page that fetches and displays a character's detailed info based on the
/// received id.
class CharacterDetailPage extends StatefulWidget {
  const CharacterDetailPage({
    this.id,
    this.name,
    Key key,
  })  : assert(id != null || name != null),
        super(key: key);

  final int id;
  final String name;

  @override
  _CharacterDetailPageState createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  CharacterDetailBloc _bloc;
  static const _bodyItemsSpacing = 8.0;

  @override
  void initState() {
    _bloc =
        CharacterDetailBloc(characterName: widget.name, characterId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: _bloc.onNewState,
        builder: (context, snapshot) {
          final snapshotData = snapshot.data;
          final appBarTitle =
              snapshotData is Success ? snapshotData.character.name : '';

          return Scaffold(
            appBar: AppBar(
              title: Text(appBarTitle),
            ),
            body: _buildScaffoldBody(context, snapshot),
          );
        },
      );

  Widget _buildScaffoldBody(BuildContext context, AsyncSnapshot snapshot) =>
      AsyncSnapshotResponseView<Loading, Error, Success>(
        snapshot: snapshot,
        onTryAgainTap: () => _bloc.onTryAgain.add(null),
        successWidgetBuilder: (context, successState) {
          final character = successState.character;
          return Padding(
            padding: const EdgeInsets.all(
              _bodyItemsSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(character.pictureUrl),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                LabeledText(
                  label: 'Name',
                  description: character.name,
                  horizontalAndBottomPadding: _bodyItemsSpacing,
                ),
                LabeledText(
                  label: 'Nickname',
                  description: character.nickname,
                  horizontalAndBottomPadding: _bodyItemsSpacing,
                ),
                LabeledText(
                  label: 'Actor Name',
                  description: character.actorName,
                  horizontalAndBottomPadding: _bodyItemsSpacing,
                ),
                LabeledText(
                  label: 'Vital Status',
                  description: character.vitalStatus,
                  horizontalAndBottomPadding: _bodyItemsSpacing,
                ),
                LabeledText(
                  label: 'Occupations',
                  description: character.occupations.join(', '),
                  horizontalAndBottomPadding: _bodyItemsSpacing,
                ),
                LabeledText(
                  label: 'Seasons',
                  description: character.seasons.join(', '),
                  horizontalAndBottomPadding: _bodyItemsSpacing,
                ),
              ],
            ),
          );
        },
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
