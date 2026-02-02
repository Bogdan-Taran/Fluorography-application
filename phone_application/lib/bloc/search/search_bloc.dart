import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/multipleGroupsModel.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';

import '../../services/search_service.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchService _SearchService = SearchService();

  SearchBloc() : super(SearchInitial()) {
    on<SearchChangedEvent>(searchChangedEvent);
  }

  FutureOr<void> searchChangedEvent(
    SearchChangedEvent event,
    Emitter<SearchState> emit,
  ) {
    List<SingleGroupWithStudentsModel> allGroups = [];
    List<StaffAndStudentsModel> entireGroups = event.entireGroups;
    List<MultiplieGroupsModel> filteredGroups = [];
    final query = event.query;
    if (query.isEmpty) {
      print('Bloc: query пустой');
      emit(SearchNotFoundState());
    }
    print('Bloc: пришёл query: $query');
    filteredGroups = _SearchService.filterGroups(
      query: query,
      filteredEntireGroups: entireGroups,
      // filteredGroups: allGroups,
    );
    if(filteredGroups != null){
      print('Отфильтровал. Вот что получилось: ${filteredGroups}');
      emit(SearchUpdatedState(filteredGroups: filteredGroups));
    }
    emit(SearchNotFoundState());

  }
}
