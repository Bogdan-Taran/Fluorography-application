import 'package:project_fluorography/models/multipleGroupsModel.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';

class SearchService{
  List<MultiplieGroupsModel> filterGroups({
    List<SingleGroupWithStudentsModel>? filteredGroups,
    List<StaffAndStudentsModel>? filteredEntireGroups,
    required String query}){

    if(filteredGroups != null && filteredGroups.isNotEmpty){
      return filteredGroups.map((e) {
        final matchingItem = e.students.where((s) => s.searchKey.contains(query)).toList();
        return matchingItem.isEmpty ? null : e.copyWith(students: matchingItem);
      }).whereType<SingleGroupWithStudentsModel>().cast<MultiplieGroupsModel>().toList();
    }
    else if(filteredEntireGroups != null && filteredEntireGroups.isNotEmpty){
      return filteredEntireGroups.cast<MultiplieGroupsModel>();
    }
    return [];
  }
}


// //функция для фильтрации
// List<GroupWithStudents> _filterGroups(
//   List<GroupWithStudents> groups,
//   String query,
// ) {
//   return groups
//       .map((group) {
//         final matchingStudents = group.students.where((s) => s.searchKey.contains(query)).toList();
//         return matchingStudents.isEmpty ? null : group.copyWith(students: matchingStudents);
//       })
//       .whereType<GroupWithStudents>()
//       .toList();
// }


//   // массивы для посика
//   List<GroupWithStudents> _allGroups = [];
//   List<GroupWithStudents> _filteredGroups = [];
//
//   Timer? _debounceTimer;

// void initState() {
//     super.initState();
//     _futureGroups = fetchAllGroupsWithStudents().then((data) {
//       _allGroups = data;
//       _filteredGroups = data;
//       return data;
//     });
//
//     searchController.addListener(_onSearchChanged);
//   }


//   void _onSearchChanged() {
//     _debounceTimer?.cancel();
//     _debounceTimer = Timer(Duration(milliseconds: 400), (){
//       final query = searchController.text.trim().toLowerCase();
//
//       if (query.isEmpty) {
//         _updateFilteredGroups(_allGroups);
//       } else if(query.length >= 3){
//         final filtred = _filterGroups(_allGroups, query);
//         _updateFilteredGroups(filtred);
//       }
//     });
//   }
//
//   void _updateFilteredGroups(List<GroupWithStudents> groups){
//     if(mounted){
//       setState(() {
//         _filteredGroups = groups;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     searchController.removeListener(_onSearchChanged);
//     searchController.dispose();
//     super.dispose();
//   }
//






// return SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 8,
//                         ),
//                         child: AccordionListBuild(groups: _filteredGroups),
//                       ),
//                     );