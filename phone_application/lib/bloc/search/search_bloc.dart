import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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

  FutureOr<void> searchChangedEvent(SearchChangedEvent event, Emitter<SearchState> emit) {
    List<SingleGroupWithStudentsModel> allGroups = [];
    List <StaffAndStudentsModel>  entireGroups = [];
    List<dynamic> filteredGroups = [];
    Timer timerDuration = Timer(Duration(milliseconds: 400), (){
        final query = event.query;

        if(query.isEmpty){
          emit(SearchUpdatedState(filteredGroups: filteredGroups));
        } else if(query.length >= 3){
          final List filtered = _SearchService.filterGroups(query: query, filteredEntireGroups: entireGroups, filteredGroups: allGroups);
          emit(SearchUpdatedState(filteredGroups: filtered));
        }
    });



  }
}
