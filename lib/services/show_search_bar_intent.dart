import 'package:flutter/material.dart';

/// An intent that is bound to [ShowSearchBarAction] to show the search bar in
/// its [BuildContext].
class ShowSearchBarIntent extends Intent {
  const ShowSearchBarIntent();
}

/// An action that is bound to [ShowSearchBarAction] that shows the search bar
/// in its [BuildContext].
class ShowSearchBarAction extends Action<ShowSearchBarIntent> {
  final BuildContext context;

  ShowSearchBarAction(this.context);

  @override
  Object? invoke(covariant ShowSearchBarIntent intent) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return const SizedBox();
      },
    );
  }
}
