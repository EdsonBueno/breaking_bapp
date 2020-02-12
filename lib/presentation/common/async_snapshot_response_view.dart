import 'package:breaking_bapp/presentation/common/centered_progress_indicator.dart';
import 'package:breaking_bapp/presentation/common/error_indicator.dart';
import 'package:flutter/widgets.dart';

/// Chooses between a [CenteredProgressIndicator], an [ErrorIndicator] or a
/// content widget by matching the snapshot's data with the provided generic
/// types.
class AsyncSnapshotResponseView<Loading, Error, Success>
    extends StatelessWidget {
  AsyncSnapshotResponseView({
    @required this.contentWidgetBuilder,
    @required this.snapshot,
    this.onTryAgainTap,
    Key key,
  })  : assert(contentWidgetBuilder != null),
        assert(snapshot != null),
        assert(Loading != dynamic),
        assert(Error != dynamic),
        assert(Success != dynamic),
        super(key: key);

  final AsyncSnapshot snapshot;
  final GestureTapCallback onTryAgainTap;
  final Widget Function(BuildContext context, Success success)
      contentWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    final snapshotData = snapshot.data;
    if (snapshotData == null || snapshotData is Loading) {
      return CenteredProgressIndicator();
    }

    if (snapshotData is Error) {
      return ErrorIndicator(
        onActionButtonPressed: onTryAgainTap,
      );
    }

    if (snapshotData is Success) {
      return contentWidgetBuilder(context, snapshotData);
    }

    throw UnknownStateTypeException();
  }
}

class UnknownStateTypeException implements Exception {}
