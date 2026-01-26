part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

final class SearchInitial extends SearchState {}

class SearchUpdatedState extends SearchState{
  final List filteredGroups;
  SearchUpdatedState({required this.filteredGroups});
}
class SearchLoadingState extends SearchState{}
class SearchErrorState extends SearchState{}
