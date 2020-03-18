import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Combines the VisibilityDetector with WidgetsBindingObserver (only needed
/// on Android) in order to identify whenever a Widget is visible or not.
class FocusDetector extends StatefulWidget {
  /// Constructor.
  ///
  ///
  /// `key` is required to properly identify this widget; it must be unique
  /// among all [FocusDetector] widgets.
  const FocusDetector({
    @required Key key,
    @required this.child,
    this.onFocusGained,
    this.onFocusLost,
  })  : assert(key != null),
        assert(child != null),
        super(key: key);

  final VoidCallback onFocusGained;
  final VoidCallback onFocusLost;
  final Widget child;

  @override
  _FocusDetectorState createState() => _FocusDetectorState();
}

class _FocusDetectorState extends State<FocusDetector>
    with WidgetsBindingObserver {
  bool _isVisible = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // It only makes sense to report the focus change when the app's lifecycle
    // state changes while this Widget was visible.
    if (state == AppLifecycleState.resumed &&
        _isVisible &&
        widget.onFocusGained != null) {
      widget.onFocusGained();
    }

    if (state == AppLifecycleState.paused &&
        _isVisible &&
        widget.onFocusLost != null) {
      widget.onFocusLost();
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: widget.key,
        onVisibilityChanged: (visibilityInfo) {
          // In order to know if we're visible or not, we just need to make
          // sure that our visible fraction is greater than zero.
          _isVisible = visibilityInfo.visibleFraction > 0;
          if (_isVisible && widget.onFocusGained != null) {
            widget.onFocusGained();
          }

          if (!_isVisible && widget.onFocusLost != null) {
            widget.onFocusLost();
          }
        },
        child: widget.child,
      );

  @override
  void initState() {
    // We only need the WidgetsBindingObserver strategy on Android, as the
    // [VisibilityDetector] is enough on iOS.
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addObserver(this);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }
}
