part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}


class OnActiveManualMark extends SearchEvent {}

class OnDisableManualMark extends SearchEvent {}

class OnAddToHistory extends SearchEvent {
  
  final SearchResult result;
  OnAddToHistory(this.result);

}