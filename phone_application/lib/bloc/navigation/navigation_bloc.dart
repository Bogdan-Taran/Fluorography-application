import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {

    @override
    Stream<NavigationState> mapEventToState(
      NavigationEvent event,
    ) async* {
      if (event is AppStartedEvent || event is AppNavigateToCuratorPageEvent){
        yield CuratorPageState();
      } else if (event is AppNavigateToLoginPageEvent) {
        yield LoginPageState();
      }
    }

  }
}
