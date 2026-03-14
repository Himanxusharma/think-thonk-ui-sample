import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../feed/models/idea.dart';
import '../../interactions/controllers/interaction_controller.dart';

final shareControllerProvider = Provider((ref) {
  return ShareController(ref);
});

class ShareController {
  final Ref _ref;
  const ShareController(this._ref);

  Future<void> share(Idea idea) async {
    try {
      await Share.share(
        '${idea.headline}\n\n${idea.content}',
        subject: idea.headline,
      );
      _ref
          .read(interactionControllerProvider.notifier)
          .markShared(idea.id);
    } catch (_) {
      // Silently handle share errors
    }
  }
}
