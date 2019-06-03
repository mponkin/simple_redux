import 'package:simple_redux/simple_redux.dart';

void main() {
  final reducers = <Reducer<double>>[
    (state, action) {
      if (action is Add) {
        return state + action.argument;
      }

      return state;
    },
    (state, action) {
      if (action is Subtract) {
        return state - action.argument;
      }

      return state;
    },
    (state, action) {
      if (action is Multiply) {
        return state * action.argument;
      }

      return state;
    },
    (state, action) {
      if (action is Negation) {
        return -state;
      }

      return state;
    },
  ];
  final store = SimpleStore<double>(0, reducers: reducers);

  Dispatch disp;
  final unsub = store.subscribe((state, dispatch) {
    print("State is: $state");
    disp = dispatch;
  });

  disp(Add(15));
  disp(Subtract(12));
  disp(Multiply(40));
  disp(Negation());
}

class Add extends Action {
  final double argument;

  Add(this.argument);
}

class Subtract extends Action {
  final double argument;

  Subtract(this.argument);
}

class Multiply extends Action {
  final double argument;

  Multiply(this.argument);
}

class Negation extends Action {}
