import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool notifications;
  final bool emailDigest;
  final bool privateProfile;
  final bool showActivity;

  const SettingsState({
    this.notifications = true,
    this.emailDigest = false,
    this.privateProfile = false,
    this.showActivity = true,
  });

  SettingsState copyWith({
    bool? notifications,
    bool? emailDigest,
    bool? privateProfile,
    bool? showActivity,
  }) {
    return SettingsState(
      notifications: notifications ?? this.notifications,
      emailDigest: emailDigest ?? this.emailDigest,
      privateProfile: privateProfile ?? this.privateProfile,
      showActivity: showActivity ?? this.showActivity,
    );
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController();
});

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState());

  void toggle(String key) {
    state = switch (key) {
      'notifications' => state.copyWith(notifications: !state.notifications),
      'emailDigest' => state.copyWith(emailDigest: !state.emailDigest),
      'privateProfile' => state.copyWith(privateProfile: !state.privateProfile),
      'showActivity' => state.copyWith(showActivity: !state.showActivity),
      _ => state,
    };
  }
}
