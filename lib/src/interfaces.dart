typedef Reducer<State> = State Function(State oldState, Action action);

typedef Next<State> = Action Function(State, Action, Dispatch);

typedef Middleware<State> = Action Function(
    State, Action, Dispatch, Next<State>);

typedef Dispatch = Function(Action);

typedef Subscription<State> = Function(State, Dispatch);

typedef Unsubscribe = Function();

abstract class Action {}

abstract class Store<State> {
  Unsubscribe subscribe(Subscription<State> subscription);
}
