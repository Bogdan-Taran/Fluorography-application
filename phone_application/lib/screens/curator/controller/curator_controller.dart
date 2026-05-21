import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import '../../medic/repository/medic_repository.dart';

part 'curator_controller.g.dart';

@riverpod
class CuratorController extends _$CuratorController {
  @override
  FutureOr<List<SingleGroupWithStudentsModel>> build() async {
    return ref.watch(medicRepositoryProvider).getStudents();
  }
}

final curatorSearchQueryProvider = StateProvider<String>((ref) => '');

@riverpod
AsyncValue<List<SingleGroupWithStudentsModel>> filteredCuratorGroups(Ref ref) {
  final query = ref.watch(curatorSearchQueryProvider);
  final groupsAsync = ref.watch(curatorControllerProvider);

  return groupsAsync.whenData((groups) {
    if (query.isEmpty) return groups;

    final lowerQuery = query.toLowerCase().trim();
    final filtered = <SingleGroupWithStudentsModel>[];

    for (final group in groups) {
      final matchingStudents = group.students
          .where((s) => s.searchKey.toLowerCase().contains(lowerQuery))
          .toList();
      if (matchingStudents.isNotEmpty) {
        filtered.add(group.copyWith(students: matchingStudents));
      }
    }
    return filtered;
  });
}
