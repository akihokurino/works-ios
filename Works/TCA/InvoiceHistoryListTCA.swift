import Combine
import ComposableArchitecture
import Firebase

enum InvoiceHistoryListTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .onAppear:
            return .none
        }
    }
}

extension InvoiceHistoryListTCA {
    enum Action: Equatable {
        case onAppear
    }

    struct State: Equatable {
        var isLoading: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
