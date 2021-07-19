import Combine
import ComposableArchitecture
import Firebase

enum SupplierEditTCA {
    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .back:
            return .none
        }
    }
}

extension SupplierEditTCA {
    enum Action: Equatable {
        case back
    }

    struct State: Equatable {
        var isLoading: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
