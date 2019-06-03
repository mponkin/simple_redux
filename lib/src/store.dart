import 'interfaces.dart';

class SimpleStore<State> extends Store<State> {
  State _currentState;
  final List<Reducer<State>> _reducers = [];
  final List<Middleware<State>> _middleware = [];
  final Set<Subscription<State>> _subscriptions = {};

  SimpleStore(
    this._currentState, {
    List<Reducer<State>> reducers = const [],
    List<Middleware<State>> middleware = const [],
  }) {
    _reducers.addAll(reducers);
    _middleware.addAll(middleware);
  }

  @override
  Unsubscribe subscribe(Subscription<State> subscription) {
    _subscriptions.add(subscription);
    subscription(_currentState, _dispatch);

    return () {
      _subscriptions.remove(subscription);
    };
  }

  void _dispatch(Action action) {
    final newAction = _applyMiddleware(action);
    final newState = _applyReducers(newAction);
    if (_currentState != newState) {
      _currentState = newState;
      for (final sub in _subscriptions) {
        sub(_currentState, _dispatch);
      }
    }
  }

  State _applyReducers(Action action) =>
      _reducers.fold(_currentState, (state, reducer) => reducer(state, action));

  Action _applyMiddleware(Action action) =>
      _next(0)(_currentState, action, _dispatch);

  Next<State> _next(int index) => index == _middleware.length
      ? (_, action, __) => action
      : (State state, Action action, Dispatch dispatch) =>
          _middleware[index](state, action, dispatch, _next(index + 1));
}
