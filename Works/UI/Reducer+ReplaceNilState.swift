import ComposableArchitecture

extension Reducer {
    func replaceNilState<S>(
        with replacement: @escaping @autoclosure () -> S?
    ) -> Self where State == S? {
        .init { state, action, environment in
            guard state != nil else {
                var replacedState = replacement()
                return run(&replacedState, action, environment)
            }
            return run(&state, action, environment)
        }
    }
}
