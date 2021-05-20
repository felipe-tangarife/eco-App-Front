import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eco_app3/models/search_result.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super( SearchState() );

  @override
  Stream<SearchState> mapEventToState( SearchEvent event ) async* {
    
    if ( event is OnActiveManualMark ) {
      yield state.copyWith( manualSelect: true );

    } else if ( event is OnDisableManualMark ) {
      yield state.copyWith( manualSelect: false );

    } else if ( event is OnAddToHistory ) {

      final exists = state.history.where(
        (result) => result.destinationName == event.result.destinationName
      ).length;

      if ( exists == 0 ) {
        final newHistory = [...state.history, event.result];
        yield state.copyWith( history: newHistory );
      }
      
    }

    


  }
}
