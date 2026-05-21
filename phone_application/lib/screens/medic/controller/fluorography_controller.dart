import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/medic_repository.dart';
import 'medic_controller.dart';

part 'fluorography_controller.g.dart';

class FluorographyState {
  final Map<String, bool> editingStates;
  final Map<String, String> tempDates;

  FluorographyState({
    this.editingStates = const {},
    this.tempDates = const {},
  });

  FluorographyState copyWith({
    Map<String, bool>? editingStates,
    Map<String, String>? tempDates,
  }) {
    return FluorographyState(
      editingStates: editingStates ?? this.editingStates,
      tempDates: tempDates ?? this.tempDates,
    );
  }
}

@riverpod
class FluorographyController extends _$FluorographyController {
  @override
  FluorographyState build() {
    return FluorographyState();
  }

  void turnOnEditingMode(String sectionId) {
    state = state.copyWith(
      editingStates: {...state.editingStates, sectionId: true},
    );
  }

  void cancelEditingMode(String sectionId) {
    state = state.copyWith(
      editingStates: {...state.editingStates, sectionId: false},
      tempDates: {},
    );
  }

  void selectDate(String userId, String date) {
    state = state.copyWith(
      tempDates: {...state.tempDates, userId: date},
    );
  }

  Future<void> updateSingleFluorography(int userId, String date) async {
    final repository = ref.read(medicRepositoryProvider);
    await repository.updateFluorographyDate(userId, date);
    ref.invalidate(medicControllerProvider);
  }

  Future<void> saveChanges(String sectionId) async {
    final repository = ref.read(medicRepositoryProvider);

    if (state.tempDates.isNotEmpty) {
      
      for (final entry in state.tempDates.entries) {
        final userId = int.tryParse(entry.key);
        if (userId != null) {
          await repository.updateFluorographyDate(userId, entry.value);
        }
      }
      
      state = state.copyWith(
        tempDates: {},
        editingStates: {...state.editingStates, sectionId: false},
      );
      
      ref.invalidate(medicControllerProvider);
    } else {
      state = state.copyWith(
        editingStates: {...state.editingStates, sectionId: false},
      );
    }
  }
}
