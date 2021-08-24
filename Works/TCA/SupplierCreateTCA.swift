import Combine
import ComposableArchitecture
import Firebase

struct CreateSupplierParams: Equatable {
    let name: String
    let billingAmount: Int
    let billingType: GraphQL.GraphQLBillingType
    let endYm: String
    let subject: String
    let subjectTemplate: String
}

enum SupplierCreateTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .back:
            return .none
        case .create(let params):
            state.isLoading = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in
                    caller.createSupplier(
                        name: params.name,
                        billingAmount: params.billingAmount,
                        billingType: params.billingType,
                        endYm: params.endYm,
                        subject: params.subject,
                        subjectTemplate: params.subjectTemplate)
                }
                .receive(on: environment.mainQueue)
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
