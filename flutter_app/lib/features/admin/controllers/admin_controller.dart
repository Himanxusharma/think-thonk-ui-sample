import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_idea.dart';

class AdminState {
  final List<AdminIdea> ideas;
  final bool showForm;

  const AdminState({this.ideas = const [], this.showForm = false});

  int get totalPublished =>
      ideas.where((i) => i.status == AdminIdeaStatus.published).length;
  int get totalDrafts =>
      ideas.where((i) => i.status == AdminIdeaStatus.draft).length;

  AdminState copyWith({List<AdminIdea>? ideas, bool? showForm}) {
    return AdminState(
      ideas: ideas ?? this.ideas,
      showForm: showForm ?? this.showForm,
    );
  }
}

final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminState>((ref) {
  return AdminController();
});

class AdminController extends StateNotifier<AdminState> {
  AdminController() : super(const AdminState());

  void toggleForm() {
    state = state.copyWith(showForm: !state.showForm);
  }

  void addIdea(AdminIdea idea) {
    state = state.copyWith(
      ideas: [idea, ...state.ideas],
      showForm: false,
    );
  }
}
