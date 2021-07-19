import ComposableArchitecture

extension Reducer {
    func presents<LocalState, LocalAction, LocalEnvironment>(
        _ localReducer: Reducer<LocalState, LocalAction, LocalEnvironment>,
        state toLocalState: WritableKeyPath<State, LocalState?>,
        action toLocalAction: CasePath<Action, LocalAction>,
        environment toLocalEnvironment: @escaping (Environment) -> LocalEnvironment
    ) -> Self {
        let localEffectsId = UUID()
        var lastNonNilLocalState: LocalState?
        return Self { state, action, environment in
            let localEffects = localReducer
                .optional()
                .replaceNilState(with: lastNonNilLocalState)
                .captureState { lastNonNilLocalState = $0 ?? lastNonNilLocalState }
                .pullback(state: toLocalState, action: toLocalAction, environment: toLocalEnvironment)
                .run(&state, action, environment)
                .cancellable(id: localEffectsId)
            let globalEffects = run(&state, action, environment)
            let hasLocalState = state[keyPath: toLocalState] != nil
            return .merge(
                localEffects,
                globalEffects,
                hasLocalState ? .none : .cancel(id: localEffectsId)
            )
        }
    }
}
