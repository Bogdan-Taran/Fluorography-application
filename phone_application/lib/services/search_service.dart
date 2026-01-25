
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


// return SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 8,
//                         ),
//                         child: AccordionListBuild(groups: _filteredGroups),
//                       ),
//                     );