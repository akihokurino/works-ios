import Combine
import ComposableArchitecture
import Firebase

struct CreateSupplierParams: Equatable {
    let name: String
    let billingAmount: Int
    let billingType: GraphQL.SupplierBillingType
}

enum SupplierCreateTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .back:
            return .none
        case .create(let params):
            state.isLoading = true
            return GraphQLClient.shared.caller()
                .flatMap { caller in
                    caller.createSupplier(
                        name: params.name,
                        billingAmount: params.billingAmount,
                        billingType: params.billingType)
                }
                .catchToEffect()
                .map(SupplierCreateTCA.Action.created)
        case .created(.success(_)):
            state.isLoading = false
            return .none
        case .created(.failure(_)):
            state.isLoading = false
            return .none
        }
    }
}

extension SupplierCreateTCA {
    enum Action: Equatable {
        case back
        case create(CreateSupplierParams)
        case created(Result<Supplier, AppError>)
    }

    struct State: Equatable {
        var isLoading: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
