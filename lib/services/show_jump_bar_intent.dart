import 'package:cabin_booking/widgets/jump_bar/jump_bar.dart';
import 'package:flutter/material.dart';

/// An intent that is bound to [ShowJumpBarAction] to show the jump bar in
/// its [BuildContext].
class ShowJumpBarIntent extends Intent {
  const ShowJumpBarIntent();
}

/// An action that is bound to [ShowJumpBarAction] that shows the jump bar
/// in its [BuildContext].
class ShowJumpBarAction extends Action<ShowJumpBarIntent> {
  final BuildContext context;

  ShowJumpBarAction(this.context);

  @override
  Object? invoke(covariant ShowJumpBarIntent intent) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return JumpBar(homePageContext: context);
      },
    );
  }
}
