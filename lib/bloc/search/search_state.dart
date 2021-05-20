part of 'search_bloc.dart';

@immutable
class SearchState {

  final bool manualSelect;
  final List<SearchResult> history;

  SearchState({
    this.manualSelect = false,
    List<SearchResult> history
  }) : this.history = (history == null ) ? [] : history;

  SearchState copyWith({
    bool manualSelect,
    List<SearchResult> history
  }) => SearchState(
    manualSelect: manualSelect ?? this.manualSelect,
    history      : history ?? this.history,
  );

}