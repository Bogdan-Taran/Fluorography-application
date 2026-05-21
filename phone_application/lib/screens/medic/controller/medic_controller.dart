import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import '../repository/medic_repository.dart';

part 'medic_controller.g.dart';

@riverpod
class MedicController extends _$MedicController {
  @override
  FutureOr<List<StaffAndStudentsModel>> build() async {
    return ref.watch(medicRepositoryProvider).getEntireCommunity();
  }

  Future<void> updateDate(int userId, String date) async {
    await ref.read(medicRepositoryProvider).updateFluorographyDate(userId, date);
    ref.invalidateSelf();
  }
}

//провайдер, который хранит состояние поиска. Принимает значения прямо из поисковой строки, которые потом используются дальше
final medicSearchQueryProvider = StateProvider<String>((ref) => '');

@riverpod
AsyncValue<List<StaffAndStudentsModel>> filteredMedicCommunity(Ref ref) {
  final query = ref.watch(medicSearchQueryProvider);
  final communityAsync = ref.watch(medicControllerProvider);
  
  return communityAsync.whenData((communityList) {
    if (query.isEmpty) return communityList;
    
    final lowerQuery = query.toLowerCase().trim();
    final filtered = <StaffAndStudentsModel>[];

    for (final item in communityList) {
      final matchingStaff = item.staffList
          .where((s) => s.searchKey.toLowerCase().contains(lowerQuery))
          .toList();

      final matchingGroups = <SingleGroupWithStudentsModel>[];
      for (final group in item.studentsList) {
        final matchingStudents = group.students
            .where((s) => s.searchKey.toLowerCase().contains(lowerQuery))
            .toList();
        if (matchingStudents.isNotEmpty) {
          matchingGroups.add(group.copyWith(students: matchingStudents));
        }
      }

      if (matchingStaff.isNotEmpty || matchingGroups.isNotEmpty) {
        filtered.add(item.copyWith(
          staffList: matchingStaff,
          studentsList: matchingGroups,
        ));
      }
    }
    return filtered;
  });
}
