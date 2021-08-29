import ComposableArchitecture

extension Reducer {
    func captureState(_ capture: @escaping (_ state: State) -> Void) -> Self {
        .init { state, action, environment in
            capture(state)
            return run(&state, action, environment)
        }
    }
}
